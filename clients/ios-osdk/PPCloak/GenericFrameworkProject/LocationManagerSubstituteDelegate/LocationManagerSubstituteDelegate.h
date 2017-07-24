//
//  LocationManagerSubstituteDelegate.h
//  PPCloak
//
//  Created by Costin Andronache on 7/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
typedef CLLocation* _Nullable (^SubstituteLocationCallback)(CLLocation* location);

@interface LocationManagerSubstituteDelegate : NSObject

-(instancetype)initWithLocationSubstituteCallback:(SubstituteLocationCallback)callback;
-(void)substituteDelegate:(id<CLLocationManagerDelegate> _Nonnull)delegate forManager:(CLLocationManager*)locationManager;
-(void)removeDelegateAndManager:(CLLocationManager*)locationManager;
-(void)broadcastToDelegatesLocation:(CLLocation*)location;

NS_ASSUME_NONNULL_END
@end
