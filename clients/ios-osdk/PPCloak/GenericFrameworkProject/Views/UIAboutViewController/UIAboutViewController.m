//
//  UIAboutViewController.m
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIAboutViewController.h"
#import "UIAboutView.h"
#import "Common.h"
#import "NSBundle+RSFrameworkHooks.h"

@interface UIAboutViewController ()
@property (weak, nonatomic) IBOutlet UIAboutView *aboutView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) UIAboutViewControllerExitCallback callback;
@end

@implementation UIAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.aboutView setupWithPageInfos:[[self class] createPageInfos]];
}

-(void)setupWithCallback:(UIAboutViewControllerExitCallback)callback {
    self.callback = callback;
}

- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.callback)
}



+(NSArray<UIAboutViewPageInfo*>*)createPageInfos {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *aboutOSDKPath = [[NSBundle PPCloakBundle] pathForResource:@"aboutOSDK" ofType:@"json"];
    
    NSString *aboutOSDKJSON = [NSString stringWithContentsOfFile:aboutOSDKPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *dicts = [NSJSONSerialization JSONObjectWithData:[aboutOSDKJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    for (NSDictionary *aDict in dicts) {
        UIAboutViewPageInfo *info = [[UIAboutViewPageInfo alloc] initWithImageName:aDict[@"imageName"] text:aDict[@"text"]];
        [result addObject:info];
    }
    
    return result;
}

@end
