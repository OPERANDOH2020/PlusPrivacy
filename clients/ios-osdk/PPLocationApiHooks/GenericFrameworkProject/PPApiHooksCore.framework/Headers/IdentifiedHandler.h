//
//  IdentifiedHandler.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"

typedef void(^NextHandlerConfirmation)();
typedef void(^EventHandler)(PPEvent* _Nonnull event, NextHandlerConfirmation _Nullable nextHandlerIfAny);

@interface IdentifiedHandler : NSObject
@property (strong, nonatomic) NSString * _Nullable identifier;
@property (strong, nonatomic) EventHandler _Nullable handler;

-(instancetype _Nonnull)initWithIdentifier:(NSString* _Nullable)identifier handler:(EventHandler _Nullable)handler;
@end
