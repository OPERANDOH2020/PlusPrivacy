//
//  UISCDViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UISCDViewController.h"
#import "Common.h"

@interface UISCDViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) void (^onCloseCallback)();

@end

@implementation UISCDViewController


-(void)setupWithSCD:(NSDictionary *)scdDict onClose:(void (^)())closeCallback {
    
    [self view];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:scdDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.textView.text = jsonString;
    
    self.onCloseCallback = closeCallback;
    
}



- (IBAction)didPressBackButton:(id)sender {
    SAFECALL(self.onCloseCallback)
}




@end
