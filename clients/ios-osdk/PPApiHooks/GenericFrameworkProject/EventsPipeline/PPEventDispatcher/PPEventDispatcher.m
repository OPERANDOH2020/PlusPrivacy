//
//  PPEventDispatcher.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEventDispatcher.h"
#import "Common.h"
#import "PPEvent+FrameworkPrivate.h"


@interface PPEventDispatcher()
@property (strong, nonatomic) NSMutableArray<IdentifiedHandler*> *handlersArray;
@end

@implementation PPEventDispatcher

-(instancetype)init {
    if (self = [super init]) {
        self.handlersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(PPEventDispatcher *)sharedInstance {
    
    
    static PPEventDispatcher *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPEventDispatcher alloc] init];
    });
    return sharedInstance;
}

-(NSString*)appendNewEventHandler:(EventHandler _Nonnull)eventHandler{
    
    NSString *identifier = [NSString stringWithFormat:@"%u", arc4random()];
    IdentifiedHandler *ih = [[IdentifiedHandler alloc] initWithIdentifier:identifier handler:eventHandler];
    [self.handlersArray addObject:ih];
    return identifier;
}

-(void)removeHandlerWithIdentifier:(NSString *)identifier      {
    
    
    NSInteger index = [self.handlersArray indexOfObjectPassingTest:^BOOL(IdentifiedHandler * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IdentifiedHandler *ih = obj;
        return [ih.identifier isEqualToString:identifier];
    }];
    
    if (index != NSNotFound) {
        [self.handlersArray removeObjectAtIndex:index];
    }
}

-(void)internalFireEvent:(PPEvent*)event {
    [self fireEvent:event forHandlerAtIndex:0];
}


-(void)fireEvent:(PPEvent *)event forHandlerAtIndex:(NSInteger)index {
    if (index >= self.handlersArray.count || index < 0) {
        [event consumeWhenNoHandlerAvailable];
        return;
    }
    
    __weak PPEventDispatcher *weakSelf = self;
    
    IdentifiedHandler *ih = self.handlersArray[index];
    NextHandlerConfirmation confirmation = nil;
    if (index + 1 < self.handlersArray.count) {
        confirmation = ^{
            [weakSelf fireEvent:event forHandlerAtIndex:index + 1];
        };
    } else {
        confirmation = ^ {
            [event consumeWhenNoHandlerAvailable];
        };
    }
    
    SAFECALL(ih.handler, event, confirmation)
}


-(void)fireEvent:(PPEvent *)event      {
    
    [self internalFireEvent:event];
}

-(void)fireEventWithMaxOneTimeExecution:(PPEventIdentifier)type executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey      {
    
    
    __block BOOL didExecute = NO;
    PPVoidBlock confirmation =  ^{
        if (didExecute) {
            return;
        }
        didExecute = YES;
        SAFECALL(executionBlock)
    };
    
    NSMutableDictionary *dict = [@{
                                   executionBlockKey: confirmation
                                   } mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:type eventData:dict whenNoHandlerAvailable:executionBlock];
    
    [self fireEvent:event  ];
}

-(id)resultForEventValue:(id)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString *)key     {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    SAFEADD(dict, key, value)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:identifier eventData:dict whenNoHandlerAvailable:nil];
    
    [self fireEvent:event  ];
    
    return [event.eventData objectForKey:key] ;
}

-(BOOL)resultForBoolEventValue:(BOOL)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString *)key     {
    
    return [[self resultForEventValue:@(value) ofIdentifier:identifier atKey:key] boolValue];
}

@end
