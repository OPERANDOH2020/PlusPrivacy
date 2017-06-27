//
//  UIDevice+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPEvent.h"
#import "Common.h"
#import "PPEventDispatcher.h"
#import <UIKit/UIKit.h>

@interface UIDevice(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end
