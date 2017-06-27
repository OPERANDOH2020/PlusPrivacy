//
//  PrivacyLevelAbuseDetector.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PrivacyLevelAbuseDetector.h"

@interface PrivacyLevelAbuseDetector()
@property (strong, nonatomic) SCDDocument *document;
@end

@implementation PrivacyLevelAbuseDetector

-(instancetype)initWithDocument:(SCDDocument *)document {
    if (self = [super init]) {
        self.document = document;
    }
    
    return self;
}

-(PPPrivacyLevelViolationReport *)detectViolationForInput:(AccessedInput *)input overNetworkRequest:(NSURLRequest *)request {
    
    return nil;
}

@end
