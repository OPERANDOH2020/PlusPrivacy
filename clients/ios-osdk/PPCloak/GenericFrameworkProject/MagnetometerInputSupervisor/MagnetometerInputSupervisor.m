//
//  MagnetometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MagnetometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import "JRSwizzle.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface MagnetometerInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *magnetoSensor;
@end



@implementation MagnetometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.magnetoSensor = [CommonUtils extractInputOfType: InputType.Magnetometer from:model.scdDocument.accessedInputs];
}

-(void)processMagnetometerStatus {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.magnetoSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Magnetometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
