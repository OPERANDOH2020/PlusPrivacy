//
//  RandomWalkGenerator.h
//  PPCloak
//
//  Created by Costin Andronache on 4/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface RandomWalkBoundCircle : NSObject
@property (readonly, nonatomic) CLLocationCoordinate2D center;
@property (readonly, nonatomic) double radiusInKm;

-(instancetype)initWithCenter:(CLLocationCoordinate2D)center radiusInKm:(double)radius;

@end

@interface RandomWalkGenerator : NSObject

-(void)generateRandomWalkInCircle:(RandomWalkBoundCircle*)circle withCompletion:(void(^)(NSArray<CLLocation*>* locations))completion;

@end
