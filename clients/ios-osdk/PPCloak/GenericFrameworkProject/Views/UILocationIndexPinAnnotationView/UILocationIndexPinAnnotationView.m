//
//  UILocationIndexPinAnnotationView.m
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationIndexPinAnnotationView.h"
#import "CommonViewUtils.h"

@interface UILocationIndexPinAnnotationView()
@property (readwrite, strong, nonatomic) UILocationIndexPinView *locationIndexPinView;
@end

@implementation UILocationIndexPinAnnotationView

-(void)commonInit {
    self.locationIndexPinView = [[UILocationIndexPinView alloc] initWithFrame:self.bounds];
    [CommonViewUtils fullyConstrainView:self.locationIndexPinView inHostView:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)setVisuallyBigger:(BOOL)visuallyBigger {
    
    _visuallyBigger = visuallyBigger;
    
    CGAffineTransform transform;
    if (visuallyBigger) {
        transform = CGAffineTransformMakeScale(1.2, 1.2);
    } else {
        transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.locationIndexPinView.transform = transform;
    } completion:nil];
}



@end
