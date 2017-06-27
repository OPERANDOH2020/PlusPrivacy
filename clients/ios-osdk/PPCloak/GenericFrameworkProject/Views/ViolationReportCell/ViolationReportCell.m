//
//  ViolationReportCell.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ViolationReportCell.h"



@interface ViolationReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViolationReportCell

+(NSString *)identifierNibName {
    return @"ViolationReportCell";
}

-(void)setMessage:(NSString *)message subMessage:(NSString *)subMessage{
    self.messageLabel.text = message;
    self.dateLabel.text = subMessage;
}

@end
