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


#import "ACSwarmClientHelper.h"
#import "ACConstants.h"

@implementation ACSwarmClientHelper

#pragma mark - Private Methods

+ (NSDictionary *)dictionaryWithSwarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor {
    NSDictionary *result = nil;
    if (swarmingName != nil && command != nil && constructor!= nil) {
        result = @{
                   serverRequestParameterType.swarmingName : swarmingName,
                   serverRequestParameterType.command : command,
                   serverRequestParameterType.ctor :constructor
                   };
    } else if(swarmingName != nil && constructor!= nil) {
        result = @{
                   serverRequestParameterType.swarmingName : swarmingName,
                   serverRequestParameterType.command : @"start",
                   serverRequestParameterType.ctor :constructor
                   };
    }
    
    return result;
}

+ (NSArray *)sessionArrayWithParameters:(NSArray *)parameters sessionId:(NSString *)sessionId{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    
    if (sessionId) {
        //[result addObject:sessionId];
    }
    if (parameters) {
        [result addObjectsFromArray:parameters];
    }
    
    return [result copy];
}

+ (NSMutableDictionary *)metaDictionaryWithParameters:(NSMutableDictionary *)parameters {
    NSMutableDictionary *result = nil;
    if (parameters) {
        result = [NSMutableDictionary dictionaryWithObject:parameters forKey:serverRequestParameterType.meta];
    }
    
    return result;
}

#pragma mark - Public Methods

+ (NSDictionary *)dictionaryForServerRequestType:(NSInteger)reqType sessionId:(NSString *)sessionId swarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor arguments:(NSArray *)args {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary: [self dictionaryWithSwarmingName:swarmingName command:command ctor:constructor]];
    
    switch (reqType) {
        case ACServerRequestTypeIdentityRequest: {
            break;
        }
        case ACServerRequestTypeGeneral: {
            [result setObject:serverRequestParameterType.tenantIdForLoginRequest forKey:serverRequestParameterType.tenantId];
            [result setObject:[self sessionArrayWithParameters:args sessionId:sessionId] forKey:serverRequestParameterType.commandArguments];
            break;
        }
        default:
            break;
    }
    
    result = [self metaDictionaryWithParameters:result];
    return [result copy];
}

+ (NSDictionary *)addSession:(NSString *)session parameters:(NSDictionary *)parameters {
    NSMutableDictionary *metaDictionary = [parameters[serverRequestParameterType.meta] mutableCopy];
    NSMutableArray *tempParameters = [metaDictionary[serverRequestParameterType.commandArguments] mutableCopy];
    if (tempParameters == nil) {
        tempParameters = [[NSMutableArray alloc] initWithCapacity:1];
    }
    if (session) {
        if (tempParameters.count) {
            //[tempParameters insertObject:session atIndex:0];
        } else {
            //[tempParameters addObject:session];
        }
    }
    [metaDictionary setObject:tempParameters forKey:serverRequestParameterType.commandArguments];
    
    return [[ACSwarmClientHelper metaDictionaryWithParameters:metaDictionary] copy];
}

@end
