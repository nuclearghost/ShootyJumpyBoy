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
@property (nonatomic) BOOL onGround;
@property (nonatomic) BOOL doubleJumped;

@end

@implementation Enemy
/**
 *  Create Enemy Node
 *
 *  @param type  Variety of enemy to be created. Only one currently supported
 *  @param point point to insert enemy sprite
 *
 *  @return SKSpriteNode enemy
 */
-(id)initEnemyOfType:(int32_t)type atPoint:(CGPoint)point {
    return [self initMetAtPoint:point];
}

- (id)initMetAtPoint:(CGPoint)point {
    self = [Enemy spriteNodeWithImageNamed:@"Bunny"];
    self.name = @"enemyr";
    [self setScale:0.15];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kEnemyCategory;
    self.physicsBody.restitution = 0;
    self.physicsBody.contactTestBitMask = kPlayerCategory | kPlayerProjectileCategory | kWallCategory | kHazardCategory;
    self.physicsBody.collisionBitMask ^= kPlayerProjectileCategory;
    self.position = point;
    
    self.health = 2;
    
    SKAction *moveEnemy = [SKAction moveToX:kXDeletePoint duration:2];
    
    [self runAction:[SKAction sequence:@[moveEnemy, [SKAction removeFromParent]]]];

    SKAction *wait = [SKAction waitForDuration:0.75];
    SKAction *callEnemies = [SKAction runBlock:^{
        [self jump];
    }];
    SKAction *updateEnemies = [SKAction sequence:@[wait, callEnemies]];
    [self runAction:[SKAction repeatActionForever:updateEnemies]];
    return self;
}

- (void)jump {
    if (self.onGround) {
        [self.physicsBody applyImpulse:CGVectorMake(0, 30.0) atPoint:self.position];
    }
}

- (void)shoot {
    
}

- (void)jumpAndShoot {
    [self jump];
    [self shoot];
}

/**
 *  Updates the enemies health
 *
 *  @param amount amount to decrement health
 *
 *  @return YES if health is <= 0 implying the enemy should be destroyed
 */
- (BOOL)decrementHealthBy:(NSUInteger)amount {
    self.health -= amount;
    if (self.health <= 0){
        return YES;
    } else {
        SKAction *sound = [[SoundPlayer sharedInstance] getSoundActionFromFile:@"hit.wav"];
        [self runAction:sound];
        return NO;
    }
}


- (void)setGroundContact:(BOOL)contact {
    self.onGround = contact;
}

@end
