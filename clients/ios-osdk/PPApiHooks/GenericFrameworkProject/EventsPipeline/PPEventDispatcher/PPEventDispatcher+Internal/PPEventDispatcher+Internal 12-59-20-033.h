//
//  PPEventDispatcher+Internal.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEventDispatcher.h"

@interface PPEventDispatcher(Internal)
-(void)fireEvent:(PPEvent* _Nonnull)event;
-(void)fireEventWithMaxOneTimeExecution:(PPEventIdentifier)identifier executionBlock:(PPVoidBlock _Nonnull)executionBlock executionBlockKey:(NSString* _Nonnull)executionBlockKey;

-(id _Nullable)resultForEventValue:(id _Nonnull)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key;

-(BOOL)resultForBoolEventValue:(BOOL)value ofIdentifier:(PPEventIdentifier)identifier atKey:(NSString* _Nonnull)key;
@end
