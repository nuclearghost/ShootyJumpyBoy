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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)soundEffectChanged:(id)sender {
    NSLog(@"sound effect changed");
    UISwitch *toggle = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"sound_effects"];
}

- (IBAction)musicChanged:(id)sender {
    NSLog(@"music changed");
    UISwitch *toggle = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"music"];
}

- (IBAction)controlsChanged:(id)sender {
    NSLog(@"controls changed");
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    [[NSUserDefaults standardUserDefaults] setInteger:seg.selectedSegmentIndex forKey:@"controls"];
}

- (IBAction)instructionsTapped:(id)sender {
    NSLog(@"instructions tapped");
}

- (IBAction)backTapped:(id)sender {
    NSLog(@"back tapped");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
