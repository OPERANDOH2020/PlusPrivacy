//
//  CMAltimeter+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "NSObject+AutoSwizzle.h"
#import "PPEventDispatcher.h"

@interface CMAltimeter(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end
