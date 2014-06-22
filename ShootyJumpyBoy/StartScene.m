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
		self.backgroundColor = [SKColor colorWithRed:0.21 green:0.63 blue:0.59 alpha:1.0];
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"Menu Background"];
        bg.position = CGPointMake(0, 0);
        [bg setScale:0.5];
        bg.anchorPoint = CGPointZero;
        [self addChild:bg];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:kCustomFont];
		myLabel.text = @"Shooty Jumpy Boy";
		myLabel.fontSize = 30;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 3*self.frame.size.height/4);
		[self addChild:myLabel];
        
        [self addStartButton];
        [self addOptionButton];
        [self addGameCenterButton];

	}
	return self;
}

/**
 *  Create start button
 */
- (void)addStartButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(3*self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Start"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:16.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionStart:)];
    [self addChild:backButton];
}

/**
 *  Transition to myScene
 *
 *  @param notification unused
 */
- (void)transitionStart:(NSNotification *)notification {
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1.0];
    MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: myScene transition: reveal];}

/**
 *  Add options button
 */
- (void)addOptionButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Options"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:14.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionOptions:)];
    [self addChild:backButton];
}

/**
 *  Add options button
 */
- (void)addGameCenterButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/4)];
    [backButton.title setText:@"Game Center"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:10.0];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionGameCenter:)];
    [self addChild:backButton];
}

- (void)transitionGameCenter: (NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGameCenter" object:nil];
}

/**
 *  Post notification to display options screen
 *
 *  @param notification unused
 */
- (void)transitionOptions:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showOptions" object:nil];
}

@end
