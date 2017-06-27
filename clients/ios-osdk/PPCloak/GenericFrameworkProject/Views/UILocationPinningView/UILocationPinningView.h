//
//  UILocationPinningView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonLocationViewModels.h"



@interface UILocationPinningView : UIView
@property (readonly, nonatomic) NSArray<CLLocation*> *currentLocationsOnMap;

-(void)setupWithModel:(CommonLocationViewModel*)model callbacks:(CommonLocationViewCallbacks*)callbacks;

-(void)addNewLocation:(CLLocation*)location;
-(void)modifyLocationAt:(NSInteger)index toLatitude:(double)latitude andLongitude:(double)longitude;
-(void)deleteLocationAt:(NSInteger)index;
-(void)highlightLocationAt:(NSInteger)index;
-(void)clearAll;

@end
