//
//  OptionsViewController.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/1/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.soundEffectSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound_effects"];
    self.musicSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
    self.controlsSegmentSwitch.selectedSegmentIndex =[[NSUserDefaults standardUserDefaults] integerForKey:@"controls"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  Toggle sound effects on and off
 *
 *  @param sender UISwitch
 */
- (IBAction)soundEffectChanged:(id)sender {
    NSLog(@"sound effect changed");
    UISwitch *toggle = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"sound_effects"];
}

/**
 *  Toggle background music on and off
 *
 *  @param sender UISwitch
 */
- (IBAction)musicChanged:(id)sender {
    NSLog(@"music changed");
    UISwitch *toggle = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"music"];
}

/**
 *  Toggle Controls left or right
 *
 *  @param sender UISegmententedControl
 */
- (IBAction)controlsChanged:(id)sender {
    NSLog(@"controls changed");
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    [[NSUserDefaults standardUserDefaults] setInteger:seg.selectedSegmentIndex forKey:@"controls"];
}

/**
 *  Display a button with instructions based on controls
 *
 *  @param sender UIButton
 */
- (IBAction)instructionsTapped:(id)sender {
    NSLog(@"instructions tapped");
    UIButton *instructBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if (self.controlsSegmentSwitch.selectedSegmentIndex == 0) {
        [instructBtn setImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
    } else {
        [instructBtn setImage:[UIImage imageNamed:@"Right"] forState:UIControlStateNormal];
    }
    [instructBtn addTarget:self action:@selector(dismissInstructions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:instructBtn];
}

/**
 *  Close options screen
 *
 *  @param sender UIButton
 */
- (IBAction)backTapped:(id)sender {
    NSLog(@"back tapped");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Helper method to close instructions image
 *
 *  @param sender UIButton
 */
- (IBAction)dismissInstructions:(id)sender {
    NSLog(@"close instructions");
    [sender removeFromSuperview];
}
@end
