//
//  UIAboutView.h
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CloakNibView.h"

@interface UIAboutViewPageInfo : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *imageName;
@end

@interface UIAboutView : CloakNibView

-(void)setupWithPageInfos:(NSArray<UIAboutViewPageInfo*>*)pageInfos;

@end
