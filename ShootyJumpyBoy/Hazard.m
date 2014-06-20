//
//  Hazard.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/19/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Hazard.h"

@implementation Hazard

- (id)initHazardOfType:(uint32_t)type AtPoint: (CGPoint)point {
    self = [Hazard spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(50, 2)]
    ;
    NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Flame" ofType:
                           @"sks"];
    SKEmitterNode *projectileEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    projectileEmitter.position = CGPointMake(0, self.size.height/2);
    [self addChild:projectileEmitter];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kHazardCategory;
    self.physicsBody.dynamic = NO;
    self.position = point;
    
    SKAction *move = [SKAction moveToX:kXDeletePoint duration:2];
    
    [self runAction:[SKAction sequence:@[move, [SKAction removeFromParent]]]];
    
    return self;
}


@end
