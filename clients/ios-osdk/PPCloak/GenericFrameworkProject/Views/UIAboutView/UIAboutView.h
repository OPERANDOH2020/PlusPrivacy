//
//  UIAboutView.h
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CloakNibView.h"

@interface UIAboutViewPageInfo : NSObject
@property (readonly, nonatomic) NSString *text;
@property (readonly, nonatomic) NSString *imageName;

-(instancetype)initWithImageName:(NSString*)imageName text:(NSString*)text;
@end

@interface UIAboutView : CloakNibView

-(void)setupWithPageInfos:(NSArray<UIAboutViewPageInfo*>*)pageInfos;

@end
