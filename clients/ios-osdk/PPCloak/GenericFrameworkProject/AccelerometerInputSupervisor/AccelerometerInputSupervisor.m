//
//  AccelerometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "AccelerometerInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"
#import "PPUnlistedInputAccessViolation.h"


@interface AccelerometerInputSupervisor()

@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accSensor;

@end


@implementation AccelerometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    
    
    self.accSensor = [CommonUtils extractInputOfType: InputType.Accelerometer from:model.scdDocument.accessedInputs];
}


-(void)processAccelerometerStatus{
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess{
    if (self.accSensor) {
        return nil;
    }
    
    return  [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Accelerometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
