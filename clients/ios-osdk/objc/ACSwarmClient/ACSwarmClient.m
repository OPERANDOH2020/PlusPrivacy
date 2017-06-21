/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Cătălin Pomîrleanu (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */


#import "SIOSocket.h"

#import "AppCore.h"
#import "ApplicationConstants.h"
#import "NSDictionary+StringValue.h"

#import "ACSwarmClient.h"
#import "ACConstants.h"
#import "ACGeneralMethods.h"
#import "ACUserDefaultsManager.h"
#import "ACSwarmClientHelper.h"

@interface ACSwarmClient ()

@property (nonatomic, strong, readonly) NSString *sessionId;

@property (nonatomic, strong) SIOSocket *socket;

@property (strong) NSMutableArray *emitsArray;
@property (nonatomic, unsafe_unretained) BOOL hasIdentity;
@property (nonatomic, unsafe_unretained) BOOL isConnecting;
@property (nonatomic, unsafe_unretained) BOOL didObtainIdentity;

@end

@implementation ACSwarmClient

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    
    if(self) {
        _emitsArray = [[NSMutableArray alloc] initWithCapacity:1];
        _hasIdentity = NO;
        _isConnecting = NO;
        _didObtainIdentity = NO;
        [ACGeneralMethods addObserver:self notificationName:[ApplicationConstants notificationNameWithSwarmName: swarmingIdentityRequest.swarmingNameValue] selector:@selector(didReceiveLoginNotification:) object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)didReceiveLoginNotification:(NSNotification *)notification  {
    if (notification != nil) {
        if([notification object] != nil) {
            id notificationObject = [[notification object] firstObject];
            if (notificationObject != nil) {
                if ([notificationObject isKindOfClass:[NSDictionary class]]) {
                    BOOL authenticated = [[notificationObject objectForKey:serverRequestParameterType.authenticated] boolValue];
                    if (authenticated) {
                        NSString *username = [notificationObject objectForKey:serverRequestParameterType.userId];
                        NSString *password = [notificationObject objectForKey:serverRequestParameterType.authorisationToken];
                        [ACUserDefaultsManager storeUsername:username password:password];
                        [ACUserDefaultsManager setUserLoginValueToTrue];
                        [[AppCore sharedInstance].currentUser requestUserInformation:username];
                        [[AppCore sharedInstance].currentUserNotificationsManager requestNotifications];
                    } else {
                        [[AppCore sharedInstance].currentUser failLogin];
                    }
                }
            }
        }
    }
}

#pragma mark - Private Methods

- (void)didRegisterWithIdentity:(NSString *)identity {
    _sessionId = identity;
    _isConnecting = NO;
    _hasIdentity = YES;
    
    for (NSInteger index = 0; index < _emitsArray.count; index++) {
        NSDictionary *item = [ACSwarmClientHelper addSession:_sessionId parameters:_emitsArray[index]];
        [self sendParameters:item];
    }
    [_emitsArray removeAllObjects];
}

- (void)getIdentity {
    NSDictionary *requestDictionary = [ACSwarmClientHelper dictionaryForServerRequestType:ACServerRequestTypeIdentityRequest sessionId:nil swarmingName:swarmingIdentityRequest.swarmingNameValue command:swarmingIdentityRequest.commandValue ctor:swarmingIdentityRequest.ctorValue arguments:nil];
    [self sendParameters:requestDictionary];
}

- (void)didCreateSocket:(SIOSocket *)socket {
    _socket = socket;
    
    [self setConnectionCallbackFunctions:self];
    [self setCallbackFunctions];
    [self getIdentity];
}

#pragma mark - Callback Functions

- (void)setConnectionCallbackFunctions:(ACSwarmClient *)weakSelf {
    _socket.onConnect = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didConnectToServer];
        });
    };
    
    _socket.onDisconnect = ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didDisconnectFromServer];
        });
    };
    
    _socket.onError = ^(NSDictionary *errorInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didReceivedErrorOnConnection:errorInfo];
        });
    };
    
    _socket.onReconnect = ^(NSInteger numberOfAttempts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didReconnectToServer:numberOfAttempts];
        });
        
    };
    
    _socket.onReconnectionAttempt = ^(NSInteger numberOfAttempts){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didAttemptToReconnectToServer:numberOfAttempts];
        });
    };
    
    _socket.onReconnectionError = ^(NSDictionary *errorInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf didReceiveErrorOnReconnectionAttempt:errorInfo];
        });
    };
    
}

- (void)setCallbackFunctions {
    [_socket on:serverMesageName.message callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveMessageFromServer:args];
        });
    }];
    [_socket on:serverMesageName.connect callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveConnectingMessageFromServer:args];
        });
    }];
    [_socket on:serverMesageName.data callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveDataFromServer:args];
        });
    }];
    [_socket on:serverMesageName.error callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveErrorMessageFromServer:args];
        });
    }];
    [_socket on:serverMesageName.disconnect callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveDisconnectingMessageFromServer:args];
        });
    }];
    [_socket on:serverMesageName.retry callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveRetryMessageFromServer:args];
        });
    }];
    [_socket on:serverMesageName.reconnect callback:^(NSArray *args) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveReconnectingMessageFromServer:args];
        });
    }];
}

#pragma mark - Server Responses

- (void)didReceiveMessageFromServer:(NSArray *)responseArray {
    id responseObject = [responseArray firstObject];
    if([responseObject isKindOfClass:[NSDictionary class] ]) {
        id credentials = [responseObject objectForKey:serverRequestParameterType.meta];
        if ([credentials isKindOfClass:[NSDictionary class]]) {
            id currentSession = credentials[serverRequestParameterType.sessionId];
            if ([currentSession isKindOfClass:[NSString class]]) {
                if(_didObtainIdentity){
                    NSString *swarmName = [credentials stringForKey:serverRequestParameterType.swarmingName];
                    if (swarmName != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:[ApplicationConstants notificationNameWithSwarmName:swarmName] object:responseArray];                    }
                } else {
                    [self didRegisterWithIdentity:currentSession];
                    _didObtainIdentity = YES;
                }
            }
        }
    }
}

- (void)didReceiveConnectingMessageFromServer:(NSArray *)responseArray {
}

- (void)didReceiveDataFromServer:(NSArray *)responseArray {
    
}

- (void)didReceiveErrorMessageFromServer:(NSArray *)responseArray {
    
}

- (void)didReceiveDisconnectingMessageFromServer:(NSArray *)responseArray {
    
}

- (void)didReceiveRetryMessageFromServer:(NSArray *)responseArray {
    
}

- (void)didReceiveReconnectingMessageFromServer:(NSArray *)responseArray {
    
}

#pragma mark - Connection Monitoring Methods

- (void)didConnectToServer {
    
}

- (void)didDisconnectFromServer {
    
}

- (void)didReceivedErrorOnConnection:(NSDictionary *)errorInfo {
    
}

- (void)didReconnectToServer:(NSInteger)numberOfAttempts {
    
}

- (void)didAttemptToReconnectToServer:(NSInteger)numberOfAttempts {
    
}

- (void)didReceiveErrorOnReconnectionAttempt:(NSDictionary *)errorInfo {
    
}

#pragma mark - Helpers

- (void)emitCommandWithArguments:(NSDictionary *)arguments {
    if (arguments) {
        if (_hasIdentity) {
            [self sendParameters:arguments];
            
        } else {
            [_emitsArray addObject:arguments];
            [self createSocket];
        }
    }
}

-  (void)sendParameters:(NSDictionary *)arguments {
    [_socket emit:@"message" args:@[arguments]];
}

#pragma mark - Public Methods

- (void)createSocket {
    if (!_isConnecting) {
        _isConnecting = YES;
        [SIOSocket socketWithHost:ServerURL response:^(SIOSocket *socket) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didCreateSocket:socket];
            });
        }];
    }
}

- (void)emitRequestWithSwarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor arguments:(NSArray *)args serverRequestType:(NSInteger)reqType{
    NSDictionary *requestDictionary = [ACSwarmClientHelper dictionaryForServerRequestType:reqType sessionId:_sessionId swarmingName:swarmingName command:command ctor:constructor arguments:args];
    [self emitCommandWithArguments:requestDictionary];
}

- (void)getLoginApprovalForUsername:(NSString *)username andPassword:(NSString *)password {
    [self emitRequestWithSwarmingName:swarmingLoginRequest.swarmingNameValue command:swarmingLoginRequest.commandValue ctor:swarmingLoginRequest.ctorValue arguments:@[@"nil",username, password] serverRequestType:ACServerRequestTypeGeneral];
}

@end
