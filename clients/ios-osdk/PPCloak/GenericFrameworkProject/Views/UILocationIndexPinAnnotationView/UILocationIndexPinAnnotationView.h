//
//  UILocationIndexPinAnnotationView.h
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UILocationIndexPinView.h"

@interface UILocationIndexPinAnnotationView : MKAnnotationView
@property (readonly, nonatomic) UILocationIndexPinView *locationIndexPinView;
@property (assign, nonatomic) BOOL visuallyBigger;
@end
