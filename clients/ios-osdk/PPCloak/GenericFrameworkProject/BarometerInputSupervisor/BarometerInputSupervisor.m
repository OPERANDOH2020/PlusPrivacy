//
//  BarometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BarometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>


@interface BarometerInputSupervisor()

@property (strong, nonatomic) AccessedInput *sensor;
@property (strong, nonatomic) InputSupervisorModel *model;

@end

@implementation BarometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.sensor = [CommonUtils extractInputOfType:InputType.Barometer from:model.scdDocument.accessedInputs];
    
}


-(void)processAltimeterStatus {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.sensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Barometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
