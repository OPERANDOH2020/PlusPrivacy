//
//  ViolationReportCell.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface ViolationReportCell : UITableViewCell
+(NSString*)identifierNibName;

-(void)setMessage:(NSString*)message subMessage:(NSString*)subMessage;

@end
