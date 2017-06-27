//
//  CMMotionManager+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

//#import <CoreLocation/CoreLocation.h>
#import "PPEventDispatcher.h"
#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end
