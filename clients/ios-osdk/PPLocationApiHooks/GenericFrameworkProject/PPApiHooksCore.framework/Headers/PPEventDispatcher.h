//
//  PPEventDispatcher.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"
#import "IdentifiedHandler.h"

@interface PPEventDispatcher: NSObject

+(PPEventDispatcher* _Nonnull) sharedInstance;

-(NSString* _Nonnull)appendNewEventHandler:(EventHandler _Nonnull)eventHandler;

-(void)removeHandlerWithIdentifier:(NSString* _Nonnull)identifier;

-(void)fireEvent:(PPEvent* _Nonnull)event;

-(void)fireEventWithMaxOneTimeExecution:(PPEventIdentifier)identifier executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey;

-(id _Nullable)resultForEventValue:(id _Nonnull)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key;

-(BOOL)resultForBoolEventValue:(BOOL)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key;

@end
