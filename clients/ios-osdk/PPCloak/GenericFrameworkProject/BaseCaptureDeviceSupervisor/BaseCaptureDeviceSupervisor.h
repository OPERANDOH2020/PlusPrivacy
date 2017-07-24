//
//  BaseCaptureDeviceSupervisor.h
//  PPCloak
//
//  Created by Costin Andronache on 7/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInputSupervisor.h"

@interface NSError(AVInputSupervisor)
+(NSError*)errorCaptureDeviceBlocked;
@end

@interface BaseCaptureDeviceSupervisor : BaseInputSupervisor

@end
