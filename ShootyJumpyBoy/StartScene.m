//
//  StartScene.m
//  ShootyJumpyGuy
//
//  Created by Mark Meyer on 5/23/14.
//  Copyright (c) 2014 Steffen Itterheim. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"
//#import "GameScene.h"

@implementation StartScene

-(id) initWithSize:(CGSize)size
{
	self = [super initWithSize:size];
	if (self)
	{
		/* Setup your scene here */
		self.backgroundColor = [SKColor colorWithRed:0.21 green:0.63 blue:0.59 alpha:1.0];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
		myLabel.text = @"Shooty Jumpy Guy";
		myLabel.fontSize = 50;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 3*self.frame.size.height/4);
		[self addChild:myLabel];
        
        [self addStartButton];
        [self addOptionButton];
	}
	return self;
}

- (void)addStartButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [backButton.title setText:@"Start"];
    [backButton.title setFontName:@"Copperplate"];
    [backButton.title setFontSize:20.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionStart:)];
    [self addChild:backButton];
    /*
    SKLabelNode* startLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    startLabel.text = @"Start";
    startLabel.fontSize = 30;
    startLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:startLabel];
    
    KKButtonBehavior *buttonBehavior = [KKButtonBehavior behavior];
    buttonBehavior.selectedScale = 1.2;
    [startLabel addBehavior:buttonBehavior];
    
    [self observeNotification:KKButtonDidExecuteNotification selector:@selector(transitionStart:) object:startLabel];
     */
}

- (void)transitionStart:(NSNotification *)notification {
    NSLog(@"Transition to start");
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: myScene transition: reveal];}

- (void)addOptionButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/4)];
    [backButton.title setText:@"Options"];
    [backButton.title setFontName:@"Copperplate"];
    [backButton.title setFontSize:20.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionOptions:)];
    [self addChild:backButton];
    /*
    SKLabelNode* optionLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    optionLabel.text = @"Options";
    optionLabel.fontSize = 30;
    optionLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/4);
    [self addChild:optionLabel];
    
    KKButtonBehavior *buttonBehavior = [KKButtonBehavior behavior];
    buttonBehavior.selectedScale = 1.2;
    [optionLabel addBehavior:buttonBehavior];
    
    [self observeNotification:KKButtonDidExecuteNotification selector:@selector(transitionOptions:) object:optionLabel];
     */
}

- (void)transitionOptions:(NSNotification *)notification {
    NSLog(@"Transition to options");
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: myScene transition: reveal];
}

@end
