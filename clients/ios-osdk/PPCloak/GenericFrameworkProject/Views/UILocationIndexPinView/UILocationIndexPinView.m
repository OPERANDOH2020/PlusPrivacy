//
//  UILocationIndexPinView.m
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationIndexPinView.h"

@interface UILocationIndexPinView()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation UILocationIndexPinView

-(void)commonInit {
    [super commonInit];
    self.backgroundColor = [UIColor clearColor];
}

-(void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", index];
}

@end
