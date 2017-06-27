//
//  RandomWalkGenerator.m
//  PPCloak
//
//  Created by Costin Andronache on 4/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "RandomWalkGenerator.h"
#import <math.h>
#import "Common.h"



// created with the help of
// http://gis.stackexchange.com/a/25883

CLLocationCoordinate2D generateRandomLocationPoint(CLLocationCoordinate2D center, double radiusInMeters){
    static BOOL didSeed = NO;
    if (!didSeed) {
        srand48((unsigned int)time(NULL));
        didSeed = YES;
    }
    
    
    double u = drand48();
    double v = drand48();
    double radiusInDegrees = radiusInMeters / 111300;
    double w = radiusInDegrees * sqrt(u);
    double t = 2 * M_PI * v;
    double x = w * cos(t);
    double y = w * sin(t);
    
    x = x / cos(center.latitude);
    return CLLocationCoordinate2DMake(center.latitude + y, center.longitude + x);
}


// courtesy of
// http://stackoverflow.com/a/1416950

#define d2r (M_PI / 180.0)
double haversine_km(double lat1, double long1, double lat2, double long2)
{
    double dlong = (long2 - long1) * d2r;
    double dlat = (lat2 - lat1) * d2r;
    double a = pow(sin(dlat/2.0), 2) + cos(lat1*d2r) * cos(lat2*d2r) * pow(sin(dlong/2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = 6367 * c;
    
    return d;
}

@interface RandomWalkBoundCircle()
@property (readwrite, assign, nonatomic) CLLocationCoordinate2D center;
@property (readwrite, assign, nonatomic) double radiusInKm;
@end

@implementation RandomWalkBoundCircle

-(instancetype)initWithCenter:(CLLocationCoordinate2D)center radiusInKm:(double)radius {
    if (self = [super init]) {
        self.center = center;
        self.radiusInKm = radius;
    }
    return self;
}

@end

@implementation RandomWalkGenerator


-(void)generateRandomWalkInCircle:(RandomWalkBoundCircle *)circle withCompletion:(void (^)(NSArray<CLLocation *> *))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *locations = [self generateRandomWalkInCircle:circle];
        dispatch_async(dispatch_get_main_queue(), ^{
            SAFECALL(completion, locations)
        });
    });
}

-(NSArray<CLLocation *> *)generateRandomWalkInCircle:(RandomWalkBoundCircle *)circle {
    
    double stepInMeters = 25; //
    int maxNumOfTries = 1000; //
    NSMutableArray<CLLocation*> *result = [[NSMutableArray alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:circle.center.latitude longitude:circle.center.longitude];
    [result addObject:location];
    
    CLLocationCoordinate2D currentSourcePoint = circle.center;
    CLLocationCoordinate2D nextPoint;
    
    int totalTries = 0;
    while (totalTries < maxNumOfTries) {
        do {
            nextPoint = generateRandomLocationPoint(currentSourcePoint, stepInMeters);
            totalTries += 1;
        } while (haversine_km(circle.center.latitude, circle.center.longitude, nextPoint.latitude, nextPoint.longitude) >
                 circle.radiusInKm && totalTries < maxNumOfTries);
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:nextPoint.latitude longitude:nextPoint.longitude];
        [result addObject:newLocation];
        currentSourcePoint = nextPoint;
    }
    
    return result;
}

@end
