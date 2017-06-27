//
//  CLLocationManager+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <PPApiHooksCore/PPApiHooksCore.h>

@interface CLLocationManager(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end

