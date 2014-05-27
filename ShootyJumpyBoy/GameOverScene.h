//
//  GameOverScene.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"
#import "SKButton.h"
#import "StartScene.h"

@interface GameOverScene : SKScene

-(id) initWithSize:(CGSize)size andScore:(NSInteger)score;

@end
