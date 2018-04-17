//
//  PPEvent.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "PPEventIdentifier.h"


@interface PPEvent: NSObject
@property (readonly, nonatomic) PPEventIdentifier eventIdentifier;
@property (readonly, nonatomic, nullable) NSMutableDictionary *eventData;
@property (readonly, nonatomic, nullable) NSArray *moduleNamesInCallStack;

-(instancetype _Nonnull)initWithEventIdentifier:(PPEventIdentifier)eventIdentifier
                         moduleNamesInCallStack:(NSArray* _Nonnull)moduleNames
                                      eventData:(NSMutableDictionary* _Nullable)eventData whenNoHandlerAvailable:(PPVoidBlock _Nullable)whenNoHandlerAvailable;

@end
