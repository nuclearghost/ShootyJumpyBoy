//
//  OptionsViewController.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *soundEffectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controlsSegmentSwitch;

- (IBAction)soundEffectChanged:(id)sender;
- (IBAction)musicChanged:(id)sender;
- (IBAction)controlsChanged:(id)sender;
- (IBAction)instructionsTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

@end
