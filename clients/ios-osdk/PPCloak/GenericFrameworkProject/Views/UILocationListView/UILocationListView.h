//
//  UILocationListView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CloakNibView.h"
#import "CommonLocationViewModels.h"


@interface UILocationListView : CloakNibView
@property (readonly, nonatomic) NSArray<CLLocation*> *currentLocations;

-(void)setupWithModel:(CommonLocationViewModel*)model callbacks:(CommonLocationViewCallbacks*)callbacks;

-(void)addNewLocation:(CLLocation*)location;
-(void)removeLocationAt:(NSInteger)index;
-(void)modifyLocationAt:(NSInteger)index to:(CLLocation*)location;
-(void)highlightLocationAt:(NSInteger)index;

@end
