//
//  CloakNibView.h
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewUtils.h"

IB_DESIGNABLE
@interface CloakNibView : UIView

@property (readonly, nonatomic) UIView *contentView;

-(void)commonInit;
@end
