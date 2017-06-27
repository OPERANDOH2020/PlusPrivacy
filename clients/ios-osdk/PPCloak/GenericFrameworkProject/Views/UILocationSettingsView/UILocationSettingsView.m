//
//  UILocationSettingsView.m
//  PPCloak
//
//  Created by Costin Andronache on 4/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationSettingsView.h"
#import "Common.h"

@interface UILocationSettingsViewSettings()
@property (readwrite, assign, nonatomic) BOOL enabled;
@property (readwrite, assign, nonatomic) BOOL cycle;
@property (readwrite, assign, nonatomic) NSTimeInterval changeInterval;
@end

@implementation UILocationSettingsViewSettings
-(instancetype)initWithInterval:(NSTimeInterval)changeInterval cycle:(BOOL)cycle enabled:(BOOL)enabled {
    if (self = [super init]) {
        self.enabled = enabled;
        self.cycle = cycle;
        self.changeInterval = changeInterval;
    }
    return self;
}
@end

@implementation UILocationSettingsViewCallbacks
@end

@interface UILocationSettingsView() <UITextFieldDelegate>

@property (strong, nonatomic) UILocationSettingsViewCallbacks *callbacks;
@property (strong, nonatomic) UILocationSettingsViewSettings *settings;
@property (weak, nonatomic) IBOutlet UITextField *changeIntervalTF;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cycleSwitch;

@property (weak, nonatomic) IBOutlet UILabel *actionIndicatingLabel;

@end


@implementation UILocationSettingsView

-(void)commonInit {
    [super commonInit];
    self.changeIntervalTF.delegate = self;
}

-(void)setupWithCurrentSettings:(UILocationSettingsViewSettings *)settings editable:(BOOL)editable callbacks:(UILocationSettingsViewCallbacks *)callbacks {
    
    self.callbacks = callbacks;
    
    self.changeIntervalTF.userInteractionEnabled = editable;
    self.enabledSwitch.userInteractionEnabled = editable;
    self.cycleSwitch.userInteractionEnabled = editable;
    
    self.enabledSwitch.on = settings.enabled;
    self.cycleSwitch.on = settings.cycle;
    [self setSecondsInTextField:settings.changeInterval];
    
    if (editable) {
        self.actionIndicatingLabel.text = @"Edit locations:";
    } else {
        self.actionIndicatingLabel.text = @"View locations:";
    }
}


- (IBAction)didPressMapButton:(id)sender {
    SAFECALL(self.callbacks.onMapItemsPress)
}
- (IBAction)didPressListButton:(id)sender {
    SAFECALL(self.callbacks.onListItemsPress)
}


-(void)setSecondsInTextField:(NSTimeInterval)seconds {
    self.changeIntervalTF.text = [NSString stringWithFormat:@"%.2f", seconds];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSTimeInterval seconds = [textField.text doubleValue];
    [self setSecondsInTextField:seconds];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

-(UILocationSettingsViewSettings *)currentSettings {
    return [[UILocationSettingsViewSettings alloc] initWithInterval:self.changeIntervalTF.text.doubleValue cycle:self.cycleSwitch.on enabled:self.enabledSwitch.on];
}
@end
