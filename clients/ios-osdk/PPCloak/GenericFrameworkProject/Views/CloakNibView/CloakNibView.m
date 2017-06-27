//
//  CloakNibView.m
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CloakNibView.h"
#import "NSBundle+RSFrameworkHooks.h"

@interface CloakNibView()
@property (readwrite, strong, nonatomic) UIView *contentView;
@end

@implementation CloakNibView

-(void)commonInit {
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle PPCloakBundle]];
    UIView *view = [nib instantiateWithOwner:self options:nil].firstObject;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentView = view;
    [CommonViewUtils fullyConstrainView:view inHostView:self];
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

@end
