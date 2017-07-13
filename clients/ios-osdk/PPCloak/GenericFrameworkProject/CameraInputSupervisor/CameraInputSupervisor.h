//
//  CameraInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

@interface AVCameraInputSupervisor : NSObject <InputSourceSupervisor>
-(void)processCameraAccess;
-(void)processPhotoLibraryAccess;
@end
