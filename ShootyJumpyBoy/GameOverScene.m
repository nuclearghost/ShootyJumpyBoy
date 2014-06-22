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
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"Menu Background"];
        bg.position = CGPointMake(0, 0);
        [bg setScale:0.5];
        bg.anchorPoint = CGPointZero;
        [self addChild:bg];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:kCustomFont];
		myLabel.text = @"Game Over";
		myLabel.fontSize = 30;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 3*self.frame.size.height/4);
		[self addChild:myLabel];
        
        SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:kCustomFont];
		scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)score];
		scoreLabel.fontSize = 20;
		scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/2 + 20);
		[self addChild:scoreLabel];
        
        [[GCHelper sharedInstance] reportScore:score];
        
        double highScore = [[NSUserDefaults standardUserDefaults] doubleForKey:@"high_score"];
        if (score > highScore) {
            highScore = score;
            [[NSUserDefaults standardUserDefaults] setDouble:highScore forKey:@"high_score"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        SKLabelNode* highScoreLabel = [SKLabelNode labelNodeWithFontNamed:kCustomFont];
		highScoreLabel.text = [NSString stringWithFormat:@"High Score: %.0f", highScore];
		highScoreLabel.fontSize = 20;
		highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/2 - 20);
		[self addChild:highScoreLabel];
        
        [self addRetryButton];
        [self addMenuButton];
        [self addShareButton];
        
	}
	return self;
}


-(void)didMoveToView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
}

/**
 *  Adds retry button
 */
- (void)addRetryButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(3*self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Retry"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:16];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionStart:)];
    [self addChild:backButton];
}

/**
 *  Transition to MyScene
 *
 *  @param notification unused
 */
- (void)transitionStart:(NSNotification *)notification {    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
    
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1.0];
    MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];    //  Optionally, insert code to configure the new scene.
    [self.scene.view presentScene: myScene transition: reveal];}

/**
 *  Adds Menu Button
 */
- (void)addMenuButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/4, self.frame.size.height/4)];
    [backButton.title setText:@"Menu"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:16];
    [backButton setTouchUpInsideTarget:self action:@selector(transitionMenu:)];
    [self addChild:backButton];
}

/**
 *  Transition to StartScene
 *
 *  @param notification unused
 */
- (void)transitionMenu:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
    
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    StartScene* startScene = [StartScene sceneWithSize:self.view.bounds.size];
    [self.scene.view presentScene: startScene transition: reveal];
}

- (void)addShareButton {
    SKButton *backButton = [[SKButton alloc] initWithImageNamedNormal:@"ButtonNormal" selected:@"ButtonSelected"];
    [backButton setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/4)];
    [backButton.title setText:@"Share"];
    [backButton.title setFontName:kCustomFont];
    [backButton.title setFontSize:16];
    [backButton setTouchUpInsideTarget:self action:@selector(showShareSheet:)];
    [self addChild:backButton];
}

- (void)showShareSheet:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showShare" object:nil];

}
@end

