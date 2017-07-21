//
//  BaseInputSupervisor.h
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

@interface BaseInputSupervisor : NSObject <InputSourceSupervisor>

//protected properties, intended to be accessed or be set by subclasses
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accessedInput;


//-protected methods, must be overriden
-(InputType*)monitoringInputType;
-(BOOL)isEventOfInterest:(PPEvent*)event;
-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event;
-(void)specificProcessOfEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler;

//-public methods

@end
