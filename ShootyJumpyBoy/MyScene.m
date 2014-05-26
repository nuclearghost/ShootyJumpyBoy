//
//  MyScene.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()
@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKAction *jump;
//@property (strong, nonatomic) SKAction *shoot;
@property (strong, nonatomic) NSMutableArray *runTextures;

@property (strong, nonatomic) SKSpriteNode *floor;

@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) NSTimeInterval lastUpdateTime;

@end

@implementation MyScene

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initalizingScrollingBackground];
        
        self.physicsWorld.contactDelegate = self;
        
        //self.physicsWorld.gravity = CGVectorMake(0,0);
        
        [self createFloor];
        
        SKAction *wait = [SKAction waitForDuration:0.5];
        SKAction *performSelector = [SKAction performSelector:@selector(createPlayer) onTarget:self];
        SKAction *sequence = [SKAction sequence:@[wait, performSelector]];
        [self runAction:sequence];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.x <= self.size.width/2) {
            [self.player runAction:self.jump];
        } else {
            [self shootFromNode:self.player];
        }

    }
     
}

-(void)update:(CFTimeInterval)currentTime {
    if (self.lastUpdateTime)
    {
        self.dt = currentTime - self.lastUpdateTime;
    }
    else
    {
        self.dt = 0;
    }
    self.lastUpdateTime = currentTime;
    
    [self moveBg];
}

- (void)createPlayer {
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Shoot"];
    self.player.name = @"player";
    [self.player setScale:0.2];
    
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.categoryBitMask = kPlayerCategory;
    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.contactTestBitMask = kWallCategory;
    self.player.position = CGPointMake(20, 260);
    
    SKAction *changeTexture = [SKAction setTexture:[SKTexture textureWithImageNamed:@"Jump"]];
    SKAction *impulse = [SKAction performSelector:@selector(jumpNode) onTarget:self];
    //SKAction *changeTextureBack = [SKAction setTexture:[SKTexture textureWithImageNamed:@"Shoot"]];
    self.jump = [SKAction sequence:@[changeTexture, impulse]];
    
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"Run"];
    NSArray *textureNames = [runAtlas textureNames];
    self.runTextures = [NSMutableArray new];
    for (NSString *name in textureNames) {
        SKTexture *texture = [runAtlas textureNamed:name];
        [self.runTextures addObject:texture];
    }
    
    [self addChild:self.player];
    
    SKAction *run = [SKAction animateWithTextures:self.runTextures timePerFrame:0.1];
    [self.player runAction:[SKAction repeatActionForever:run]];
    
}

- (void)createFloor {
    self.floor = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
    [self.floor setScale:0.25];
    self.floor.name = @"floor";
    
    self.floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.floor.size];
    self.floor.physicsBody.categoryBitMask = kWallCategory;
    self.floor.physicsBody.dynamic = NO;
    self.floor.position = CGPointMake(20, 200);
    
    [self addChild:self.floor];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,self.dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
}

- (void)jumpNode {
    [self.player.physicsBody applyImpulse:CGVectorMake(0, 25.0) atPoint:self.player.position];
}

- (void)shootFromNode:(SKSpriteNode*)node {
    CGPoint location = [node position];
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"spark"];
    
    bullet.position = CGPointMake(location.x + node.size.width, location.y);
    bullet.scale = 1.0;
    
    bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.height/5];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = kPlayerProjectileCategory; //TODO
    bullet.physicsBody.contactTestBitMask = kEnemyCategory;
    bullet.physicsBody.collisionBitMask = 0;
    
    SKAction *fire = [SKAction moveToX:self.frame.size.width + bullet.size.width duration:2];
    SKAction *remove = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[fire, remove]]];
    
    [self addChild:bullet];
}

#pragma mark Physics Delegate
-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact: %@",contact);
}


@end
