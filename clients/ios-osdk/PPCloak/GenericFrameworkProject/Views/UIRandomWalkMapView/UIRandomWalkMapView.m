//
//  UIRandomWalkMapView.m
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIRandomWalkMapView.h"
#import "Common.h"

#define numberToText(x) [NSString stringWithFormat:@"%ld KM", x]

@implementation UIRandomWalkMapViewModel
@end

@implementation UIRandomWalkMapViewCallbacks
@end

@interface UIRandomWalkMapView() <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIView *busyView;

@property (weak, nonatomic) IBOutlet UIButton *setCenterButton;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsViewHeightConstraint;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *axes;

@property (strong, nonatomic) MKPolyline *currentDrawnPolyline;
@property (strong, nonatomic) MKCircle *currentDrawnCircle;
@property (strong, nonatomic) UIRandomWalkMapViewCallbacks *callbacks;

@property (strong, nonatomic) NSArray<CLLocation*> *currentLocations;
@property (readwrite, strong, nonatomic) RandomWalkBoundCircle *currentCircle;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;

@end

@implementation UIRandomWalkMapView

-(void)commonInit {
    [super commonInit];
    self.mapView.delegate = self;
    self.stepper.minimumValue = 1.0;
    self.stepper.maximumValue = 10.0;
}

-(void)displayAsBusy:(BOOL)busy {
    self.busyView.hidden = !busy;
}

-(void)displayPinForLocationAt:(NSInteger)index {
    if (index < 0 || index >= self.currentLocations.count) {
        return;
    }
    
    if (self.currentAnnotation) {
        [self.mapView removeAnnotation:self.currentAnnotation];
    }
    
    self.currentAnnotation = [[MKPointAnnotation alloc] init];
    self.currentAnnotation.coordinate = self.currentLocations[index].coordinate;
    self.currentAnnotation.title = @"Currently sent location";
    
    [self.mapView addAnnotation:self.currentAnnotation];
}

-(void)setupWithModel:(UIRandomWalkMapViewModel *)model callbacks:(UIRandomWalkMapViewCallbacks *)callbacks {
    self.callbacks = callbacks;
    
    [self drawNewLocations:model.initialLocations];
    [self updateCircleToCenter:model.initialCircle.center radiusInKM:model.initialCircle.radiusInKm];
    self.currentCircle = model.initialCircle;
    
    self.busyView.hidden = YES;
    
    if (!model.editable) {
        self.toolsViewHeightConstraint.constant = 0;
        for (UIView *axis in self.axes) {
            axis.hidden = YES;
        }
        
        self.setCenterButton.hidden = YES;
    }
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(model.initialCircle.center, MKCoordinateSpanMake(0.2, 0.2));
    self.mapView.region = region;
}

-(void)drawNewLocations:(NSArray<CLLocation *> *)locations{
    
    if (self.currentAnnotation) {
        [self.mapView removeAnnotation:self.currentAnnotation];
    }
    
    if (self.currentDrawnPolyline) {
        [self.mapView removeOverlay:self.currentDrawnPolyline];
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (!locations.count) {
        return;
    }
    
    CLLocationCoordinate2D* locationCoordinates = malloc(sizeof(CLLocationCoordinate2D) * locations.count);
    
    for (int i = 0; i<locations.count; i++) {
        locationCoordinates[i] = locations[i].coordinate;
    }
    
    self.currentDrawnPolyline = [MKGeodesicPolyline polylineWithCoordinates:locationCoordinates count:locations.count];
    
    free(locationCoordinates);
    
    [self.mapView addOverlay:self.currentDrawnPolyline];
    self.currentLocations = locations;
}


-(void)updateCircleToCenter:(CLLocationCoordinate2D)center radiusInKM:(double)radius {
    
    if (self.currentDrawnCircle) {
        [self.mapView removeOverlay:self.currentDrawnCircle];
    }
    
    double discreteValue = round(radius);
    [self setRadiusValue:discreteValue];
    
    self.currentDrawnCircle = [MKCircle circleWithCenterCoordinate:center radius:discreteValue * 1000];
    self.currentCircle = [[RandomWalkBoundCircle alloc] initWithCenter:center radiusInKm:discreteValue];
    
    [self.mapView addOverlay:self.currentDrawnCircle];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    NSString *identifier = @"pinView";
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    return pinView;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircle *circle = overlay;
        return [self createCircleRendererFor:circle];
    }
    
    MKGeodesicPolyline *polyline = overlay;
    return [self createPolylineRendererFor:polyline];
    
}

-(MKPolylineRenderer*)createPolylineRendererFor:(MKPolyline*)polyline {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    
    renderer.lineWidth = 3.0;
    renderer.alpha = 0.6;
    renderer.strokeColor = [UIColor blueColor];
    
    return renderer;
}

-(MKCircleRenderer*)createCircleRendererFor:(MKCircle*)circle {
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:circle];
    
    renderer.fillColor = [UIColor greenColor];
    renderer.alpha = 0.3;
    return renderer;
}


-(void)setRadiusValue:(NSInteger)value {
    self.stepper.value = value;
    self.kmLabel.text = numberToText((int)value);
}

#pragma mark - IBActions

- (IBAction)stepperDidChangeValue:(UIStepper *)sender {
    if (fabs(sender.value - self.currentCircle.radiusInKm) < 1.0) {
        return;
    }
    [self updateCircleToCenter:self.currentCircle.center radiusInKM:sender.value];
    SAFECALL(self.callbacks.onBoundCircleChange, self.currentCircle)
}

- (IBAction)didPressSetCenter:(id)sender {

    [self updateCircleToCenter:self.mapView.centerCoordinate radiusInKM:self.currentCircle.radiusInKm];
    SAFECALL(self.callbacks.onBoundCircleChange, self.currentCircle)
}


@end
