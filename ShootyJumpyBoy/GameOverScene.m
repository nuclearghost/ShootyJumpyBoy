//
//  GameOverScene.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(id) initWithSize:(CGSize)size andScore:(NSInteger)score;
{
	self = [super initWithSize:size];
	if (self)
	{
		self.backgroundColor = [SKColor colorWithRed:0.21 green:0.63 blue:0.59 alpha:1.0];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
		myLabel.text = @"Game Over";
		myLabel.fontSize = 60;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 3*self.frame.size.height/4);
		[self addChild:myLabel];
        
        SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
		scoreLabel.text = [NSString stringWithFormat:@"Score: %d", score];
		scoreLabel.fontSize = 40;
		scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/2);
		[self addChild:scoreLabel];
        
        [self addRetryButton];
        [self addMenuButton];
	}
	return self;
}

- (void)addRetryButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Retry"];
    [backButton.title setFontName:@"Copperplate"];
    [backButton.title setFontSize:20.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionStart:)];
    [self addChild:backButton];
}

- (void)transitionStart:(NSNotification *)notification {
    NSLog(@"Transition to start");
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: myScene transition: reveal];}

- (void)addMenuButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(3*self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Menu"];
    [backButton.title setFontName:@"Copperplate"];
    [backButton.title setFontSize:20.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionOptions:)];
    [self addChild:backButton];
}

- (void)transitionOptions:(NSNotification *)notification {
    NSLog(@"Transition to options");
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    StartScene* startScene = [StartScene sceneWithSize:self.view.bounds.size];
    [self.scene.view presentScene: startScene transition: reveal];
}

@end

