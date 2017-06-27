//
//  UIRandomWalkMapView.h
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CloakNibView.h"
#import "RandomWalkGenerator.h"


@interface UIRandomWalkMapViewModel: NSObject
@property (strong, nonatomic) RandomWalkBoundCircle *initialCircle;
@property (strong, nonatomic) NSArray<CLLocation*> *initialLocations;
@property (assign, nonatomic) BOOL editable;
@end

@interface UIRandomWalkMapViewCallbacks : NSObject
@property (strong, nonatomic) void(^onBoundCircleChange)(RandomWalkBoundCircle *newCircle);
@end

@interface UIRandomWalkMapView : CloakNibView
@property (readonly, nonatomic) RandomWalkBoundCircle *currentCircle;

-(void)drawNewLocations:(NSArray<CLLocation*>*)locations;
-(void)setupWithModel:(UIRandomWalkMapViewModel*)model callbacks:(UIRandomWalkMapViewCallbacks*)callbacks;
-(void)displayAsBusy:(BOOL)busy;

-(void)displayPinForLocationAt:(NSInteger)index;

@end
