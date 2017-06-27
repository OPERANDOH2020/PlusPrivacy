//
//  RandomWalkSwizzlerSettings.h
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomWalkGenerator.h"

static NSString *kCircleCenterLatitude = @"kCircleCenterLatitude";
static NSString *kCircleCenterLongitude = @"kCircleCenterLongitude";
static NSString *kCircleRadiusKM = @"kCircleRadiusKM";
static NSString *kRandomWalkPathLatitudes = @"kPathLatitudes";
static NSString *kRandomWalkPathLongitudes = @"kPathLongitudes";
static NSString *kRandomWalkEnabled = @"kRandomWalkEnabled";

@interface RandomWalkSwizzlerSettings : NSObject
@property (readonly, nonatomic) RandomWalkBoundCircle *boundCircle;
@property (readonly, nonatomic) NSArray<CLLocation*> *walkPath;
@property (readonly, nonatomic) BOOL enabled;

+(RandomWalkSwizzlerSettings*)createWithCircle:(RandomWalkBoundCircle*)circle walkPath:(NSArray<CLLocation*>*)walkPath enabled:(BOOL)enabled error:(NSError**)error;


+(RandomWalkSwizzlerSettings*)createFromDefaults:(NSUserDefaults*)defaults error:(NSError**)error;
-(void)synchronizeToDefaults:(NSUserDefaults*)defaults;


@end
