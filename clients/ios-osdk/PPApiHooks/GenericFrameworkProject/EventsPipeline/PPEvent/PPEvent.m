//
//  PPEvent.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEvent.h"
#import "PPEvent+FrameworkPrivate.h"
#import "Common.h"

@interface PPEvent()
@property (readwrite, assign, nonatomic) PPEventIdentifier eventIdentifier;
@property (readwrite, strong, nonatomic, nullable) NSMutableDictionary *eventData;
@property (strong, nonatomic) PPVoidBlock whenNoHandlerAvailable;
@property (readwrite, nonatomic, strong) NSArray *moduleNamesInCallStack;

@end

@implementation PPEvent

-(instancetype _Nonnull)initWithEventIdentifier:(PPEventIdentifier)eventIdentifier
                         moduleNamesInCallStack:(NSArray* _Nonnull)moduleNames
                                      eventData:(NSMutableDictionary* _Nullable)eventData whenNoHandlerAvailable:(PPVoidBlock _Nullable)whenNoHandlerAvailable {
    
    if (self = [super init]) {
        self.eventData = eventData;
        self.eventIdentifier = eventIdentifier;
        self.whenNoHandlerAvailable = whenNoHandlerAvailable;
        self.moduleNamesInCallStack = moduleNames;
    }
    
    return self;
}




-(void)consumeWhenNoHandlerAvailable {
    SAFECALL(self.whenNoHandlerAvailable)
}

@end
