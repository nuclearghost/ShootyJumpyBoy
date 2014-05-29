//
//  Enemy.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Enemy.h"

@interface Enemy()

@property (nonatomic) NSUInteger health;

@end

@implementation Enemy

-(id)initEnemyOfType:(int32_t)type atPoint:(CGPoint)point {
    self = [Enemy spriteNodeWithImageNamed:@"Met"];
    self.name = @"enemyr";
    [self setScale:0.1];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kEnemyCategory;
    self.physicsBody.restitution = 0;
    self.physicsBody.contactTestBitMask = kPlayerCategory | kPlayerProjectileCategory;
    self.physicsBody.collisionBitMask ^= kPlayerProjectileCategory;
    self.position = point;
    
    self.health = 2;
    
    SKAction *moveEnemy = [SKAction moveToX:0 duration:2];
    
    [self runAction:[SKAction sequence:@[moveEnemy, [SKAction removeFromParent]]]];
    
    return self;
}

- (BOOL)decrementHealthBy:(NSUInteger)amount {
    self.health -= amount;
    if (self.health <= 0){
        return YES;
    } else {
        [self runAction:[SKAction playSoundFileNamed:@"hit.wav" waitForCompletion:NO]];
        return NO;
    }
}


- (void)setGroundContact:(BOOL)contact {
    /*
    self.onGround = contact;
    if (contact) {
        [self runAction: [SKAction setTexture:[SKTexture textureWithImageNamed:@"Shoot"]]];
        self.doubleJumped = NO;
    }
     */
}

@end
