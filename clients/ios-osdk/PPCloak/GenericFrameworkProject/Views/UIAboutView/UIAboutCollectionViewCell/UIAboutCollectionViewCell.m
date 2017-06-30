//
//  UIAboutCollectionViewCell.m
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIAboutCollectionViewCell.h"
#import "NSBundle+RSFrameworkHooks.h"

@interface UIAboutCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation UIAboutCollectionViewCell

+(NSString *)identifierNibName {
    return @"UIAboutCollectionViewCell";
}


-(void)setupWithText:(NSString*)text imageName:(NSString*)imageName {
    
    self.textLabel.text = text;
    self.imageView.image = [UIImage imageNamed:imageName inBundle:[NSBundle PPCloakBundle] compatibleWithTraitCollection:nil];
}

@end
