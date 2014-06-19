//
//  Player.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Player.h"

@interface Player()

@property (strong, nonatomic) NSMutableArray *runTextures;

@property (nonatomic) BOOL onGround;
@property (nonatomic) BOOL doubleJumped;


@end

@implementation Player
/**
 *  Create a player object. Only one should be created at any time
 *
 *  @return SKSPriteNode player object
 */
-(id)init {
    self = [Player spriteNodeWithImageNamed:@"Shoot"];
    self.name = @"player";
    [self setScale:0.18];
    
    self.doubleJump = YES;
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(self.size.width * .8, self.size.height * .8) center:CGPointMake(0, 5)];
    //self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kPlayerCategory;
    self.physicsBody.restitution = 0;
    self.physicsBody.contactTestBitMask = kEnemyCategory | kEnemyProjectileCategory | kWallCategory;
    self.physicsBody.collisionBitMask ^= kPlayerProjectileCategory;
    self.position = CGPointMake(50, 260);
    
    
    SKAction *changeTexture = [SKAction setTexture:[SKTexture textureWithImageNamed:@"Jump"]];
    SKAction *impulse = [SKAction performSelector:@selector(jumpNode) onTarget:self];
    self.jumpAction = [SKAction sequence:@[changeTexture, impulse]];
    
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"Run"];
    NSArray *textureNames = [runAtlas textureNames];
    self.runTextures = [NSMutableArray new];
    for (NSString *name in textureNames) {
        SKTexture *texture = [runAtlas textureNamed:name];
        [self.runTextures addObject:texture];
    }
    
    //SKAction *run = [SKAction animateWithTextures:self.runTextures timePerFrame:0.1];
    //[self runAction:[SKAction repeatActionForever:run]];
    
    return self;
}
/**
 *  Set when the player has made contact with a platform
 *
 *  @param contact YES if player is currently in contact with platform
 */
- (void)setGroundContact:(BOOL)contact {
    self.onGround = contact;
    if (contact) {
        [self runAction: [SKAction setTexture:[SKTexture textureWithImageNamed:@"Shoot"]]];
        self.doubleJumped = NO;
    }
}
/**
 *  Apply impulse to player node to simulate jumping. Double jumping available
 */
- (void)jumpNode {
    if (self.onGround) {
        [[SoundPlayer sharedInstance] playSound:@"jump.wav"];
        [self.physicsBody applyImpulse:CGVectorMake(0, 30.0) atPoint:self.position];
    } else if (self.doubleJump && !self.doubleJumped) {
        self.doubleJumped = YES;
        [[SoundPlayer sharedInstance] playSound:@"jump.wav"];
        [self.physicsBody setVelocity:CGVectorMake(0, 0)];
        [self.physicsBody applyImpulse:CGVectorMake(0, 40.0) atPoint:self.position];
    }
}

@end
