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

//protected properties
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accessedInput;


@end
