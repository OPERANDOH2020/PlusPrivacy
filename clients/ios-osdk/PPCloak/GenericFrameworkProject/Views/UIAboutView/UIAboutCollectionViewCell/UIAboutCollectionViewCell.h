//
//  UIAboutCollectionViewCell.h
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAboutCollectionViewCell : UICollectionViewCell

+(NSString*)identifierNibName;
-(void)setupWithText:(NSString*)text imageName:(NSString*)imageName;

@end
