//
//  UserDefinedLocationsSwizzlerSettings.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserDefinedLocationsSwizzlerSettings : NSObject

@property (readonly, nonatomic) NSArray<CLLocation*>* _Nonnull locations;
@property (readonly, nonatomic) BOOL enabled;
@property (readonly, nonatomic) NSTimeInterval changeInterval;
@property (readonly, nonatomic) BOOL cycle;

-(void)synchronizeToUserDefaults:(NSUserDefaults* _Nonnull)defaults;

+(UserDefinedLocationsSwizzlerSettings* _Nullable)createWithLocations:(NSArray<CLLocation*>* _Nonnull)locations enabled:(BOOL)enabled cycle:(BOOL)cycle changeInterval:(NSTimeInterval)changeInterval error:(NSError*_Nullable*_Nullable)error;

+(UserDefinedLocationsSwizzlerSettings* _Nullable)createFromUserDefaults:(NSUserDefaults* _Nonnull)defaults error:(NSError* _Nullable *_Nullable)error;
@end
