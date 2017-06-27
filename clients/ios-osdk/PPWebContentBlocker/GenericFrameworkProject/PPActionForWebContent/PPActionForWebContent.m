//
//  PPActionForWebContent.m
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPActionForWebContent.h"

@interface PPActionForWebContent()
@property (readwrite, assign, nonatomic) WebContentActionType actionType;
@property (readwrite, strong, nonatomic, nullable) NSString *scriptToExecuteIfAny;
@end


@implementation PPActionForWebContent

-(instancetype)initWithActionType:(WebContentActionType)actionType scriptIfAny:(NSString *)script {
    
    if (self = [super init]) {
        self.actionType = actionType;
        self.scriptToExecuteIfAny = script;
    }
    return self;
}

@end
