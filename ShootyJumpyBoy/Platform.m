//
//  Platform.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/29/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Platform.h"

@implementation Platform

- (id)initAtPoint: (CGPoint)point {
    self = [Platform spriteNodeWithImageNamed:@"Floor"];
    [self setScale:0.1];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kWallCategory;
    self.physicsBody.dynamic = NO;
    //self.physicsBody.collisionBitMask = ;
    self.position = point;
        
    SKAction *move = [SKAction moveToX:0 duration:2];
    
    [self runAction:[SKAction sequence:@[move, [SKAction removeFromParent]]]];

    return self;
}

@end
