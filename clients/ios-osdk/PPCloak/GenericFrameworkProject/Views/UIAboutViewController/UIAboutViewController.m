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
    NSString *imgName = @"osdk.png";
    
    UIAboutViewPageInfo *firstPage = [[UIAboutViewPageInfo alloc] init];
    
    firstPage.text = @"The Operando Software Development Kit is a set of redistributable open-source libraries created as part of the OPERANDO H2020 project. It is intended to help app developers comply with the upcoming GDPR law, which is set to take effect in May 2018.  It provides a framework to offer a set of Privacy Enhancing Technologies that offer support for the Privacy by Design principles  and especially for the idea of enforcing the privacy through the applications code. In the long term, as part of OSDK we imagined a series of risk reducing mechanisms:";
    
    firstPage.imageName = imgName;
    
    
    
    UIAboutViewPageInfo *secondPage = [[UIAboutViewPageInfo alloc] init];
    
    secondPage.text = @"COMP or COMPLIANCE:  The application creator (OSP) creates a voluntary compliance document that formally specifies the ways in which it collects and uses the private data from the user. For example, the COMPLIANCE document can specify that an APP can read the contacts but never transmit the list to the cloud.  A COMPLIANCE document can be formally checked to verify the compliance with EU regulations.";
    
    secondPage.imageName = imgName;
    
    
    UIAboutViewPageInfo *thirdPage = [[UIAboutViewPageInfo alloc] init];
    
    thirdPage.text = @"MON or MONITOR:  The APP has the MON mechanism if it is controlled and used only together with an external application or service that can take measures to disable the application or to send warning messages to the user when COMPLIANCE violations are discovered. The discovery of wrongdoings can be automated or manual.";
    thirdPage.imageName = imgName;
    
    
    UIAboutViewPageInfo *fourthPage = [[UIAboutViewPageInfo alloc] init];
    
    fourthPage.text = @"CLOAK:  the platform or the application allows “sensor cloaking”. Sensor cloaking is a mechanism for protecting the user privacy by which the user can decide to provide bogus information to the sensors and the application can’t verify if the sensors are providing the right information. The user can decide to enter in “cloak mode” at his will.  The “cloak mode” can be considered always activated if an application is sending only anonymised information outside the application.";
    
    fourthPage.imageName = imgName;
    
    return @[firstPage, secondPage, thirdPage, fourthPage];
}

@end
