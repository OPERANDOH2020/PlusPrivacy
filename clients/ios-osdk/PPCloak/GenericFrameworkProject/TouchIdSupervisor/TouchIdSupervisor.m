//
//  TouchIdSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "TouchIdSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "JRSwizzle.h"



@interface TouchIdSupervisor()

@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accessedSensor;

@end

@implementation TouchIdSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    
    self.model = model;
    self.accessedSensor = [CommonUtils extractInputOfType: InputType.TouchID from:model.scdDocument.accessedInputs];
}



-(void)processTouchIDUsage{
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.accessedSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.TouchID dateReported:[NSDate date]];
    
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
