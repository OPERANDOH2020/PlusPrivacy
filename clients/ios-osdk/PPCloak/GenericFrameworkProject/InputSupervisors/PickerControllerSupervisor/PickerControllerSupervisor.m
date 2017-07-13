//
//  PickerControllerSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PickerControllerSupervisor.h"
#import "InputSupervisorModel.h"

@interface PickerControllerSupervisor()
@property (strong, nonatomic) AccessedInput *camSensor;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation PickerControllerSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model{
    self.model = model;
    
    
    
}

@end
