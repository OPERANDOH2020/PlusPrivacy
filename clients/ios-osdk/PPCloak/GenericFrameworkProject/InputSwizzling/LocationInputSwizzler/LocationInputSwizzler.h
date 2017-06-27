//
//  LocationInputSwizzler.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefinedLocationsSwizzlerSettings.h"
#import <CoreLocation/CoreLocation.h>
#import <PPApiHooksCore/PPApiHooksCore.h>
#import "CommonLocationViewModels.h"

typedef void(^LocationsCallback)(NSArray<CLLocation*>* _Nonnull locations);

@interface LocationInputSwizzler : NSObject

@property (readonly, nonatomic, nullable) RandomWalkSwizzlerSettings *currentSettings;
@property (readonly, nonatomic) NSInteger indexOfCurrentSentLocation;

-(void)setupWithSettings:(RandomWalkSwizzlerSettings* _Nullable)settings eventsDispatcher:(PPEventDispatcher* _Nonnull)eventsDispatcher whenLocationsAreRequested:(LocationsCallback _Nonnull)whenLocationsAreRequested;

//-(void)applyNewUserDefinedLocationsSettings:(UserDefinedLocationsSwizzlerSettings* _Nonnull)settings;
-(void)applyNewRandomWalkSettings:(RandomWalkSwizzlerSettings* _Nonnull)randomWalkSettings;

-(void)registerNewChangeCallback:(CurrentActiveLocationIndexChangedCallback _Nonnull)callback;
-(void)removeChangeCallback:(CurrentActiveLocationIndexChangedCallback _Nonnull)callback;

@end
