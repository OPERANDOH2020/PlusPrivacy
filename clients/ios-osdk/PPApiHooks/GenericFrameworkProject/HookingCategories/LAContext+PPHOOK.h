//
//  LAContext+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//


#import "Common.h"
#import "PPEventDispatcher.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LAContext(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end

