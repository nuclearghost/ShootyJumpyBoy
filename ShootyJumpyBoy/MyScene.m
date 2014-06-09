//
//  MyScene.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) SKAction *jump;
@property (strong, nonatomic) NSMutableArray *runTextures;

@property (strong, nonatomic) SKSpriteNode *floor;

@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) NSTimeInterval lastUpdateTime;

@property (strong, nonatomic) NSMutableArray *explosionTextures;

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) SKLabelNode *scoreDisplay;

@property (nonatomic) BOOL scenePaused;
@property (nonatomic) BOOL gameOverPending;
@property (nonatomic) BOOL jumpLeft;

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
    
    NSLog(@"CGSize: %@", NSStringFromCGSize(size));
    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initalizingScrollingBackground];
        
        self.physicsWorld.contactDelegate = self;
        
        [self createFloor];
        [self createPlayer];
        [self createScore];
        [self createPauseButton];
        [self playMusic];
        
        //enemies
        SKAction *wait = [SKAction waitForDuration:0.5];
        SKAction *callEnemies = [SKAction runBlock:^{
            [self generateEnemies];
        }];
        
        SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"EXPLOSION"];
        NSArray *textureNames = [explosionAtlas textureNames];
        self.explosionTextures = [NSMutableArray new];
        for (NSString *name in textureNames) {
            SKTexture *texture = [explosionAtlas textureNamed:name];
            [self.explosionTextures addObject:texture];
        }
        
        SKAction *updateEnemies = [SKAction sequence:@[wait, callEnemies]];
        [self runAction:[SKAction repeatActionForever:updateEnemies]];
        
        self.scenePaused = NO;
        self.gameOverPending = NO;
        self.jumpLeft = [[NSUserDefaults standardUserDefaults] integerForKey:@"controls"] == 0;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.x <= self.size.width/2) {
            if (self.jumpLeft) {
                [self.player runAction:self.player.jumpAction];
            } else {
                [self shootFromNode:self.player];
            }
        } else {
            if (self.jumpLeft) {
                [self shootFromNode:self.player];
            } else {
                [self.player runAction:self.player.jumpAction];
            }
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
    self.score++;
    self.scoreDisplay.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    
    [self moveBg];
    [self checkPlayerBounds];
}

- (void)createPlayer {
    self.player = [[Player alloc] init];
    [self addChild:self.player];
    
}

- (void)createFloor {
    self.floor = [SKSpriteNode spriteNodeWithImageNamed:@"Floor"];
    [self.floor setScale:0.35];
    self.floor.name = @"floor";
    
    self.floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.floor.size];
    self.floor.physicsBody.categoryBitMask = kWallCategory;
    self.floor.physicsBody.dynamic = NO;
    self.floor.position = CGPointMake(self.frame.size.width/2, 50);
    
    [self addChild:self.floor];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        bg.zPosition = -2;
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

- (void)shootFromNode:(SKSpriteNode*)node {
    CGPoint location = [node position];
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"spark"];
    
    bullet.position = CGPointMake(location.x + node.size.width/2, location.y);
    bullet.scale = 0.5;
    
    bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.height/5];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = kPlayerProjectileCategory; //TODO
    bullet.physicsBody.contactTestBitMask = kEnemyCategory | kWallCategory;
    bullet.physicsBody.collisionBitMask = kWallCategory;
    
    SKAction *fire = [SKAction moveToX:self.frame.size.width + bullet.size.width duration:2];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *laserSound = [[SoundPlayer sharedInstance] playSound:@"laser.wav"];
    
    [bullet runAction:[SKAction sequence:@[laserSound, fire, remove]]];
    
    NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Projectile" ofType:
                           @"sks"];
    SKEmitterNode *projectileEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    [bullet addChild:projectileEmitter];
    
    [self addChild:bullet];
}

- (void)generateEnemies
{
    if ([self getRandomNumberBetween:0 to:1] == 1) {
        Enemy *enemyNode = [[Enemy alloc] initEnemyOfType:1 atPoint:CGPointMake(self.frame.size.width, 260)];
        [self addChild:enemyNode];
    }
    
    if ([self getRandomNumberBetween:0 to:1] == 1) {
        BOOL rotate = [self getRandomNumberBetween:0 to:1];
        Platform *platform = [[Platform alloc] initAtPoint:CGPointMake(self.frame.size.width, rotate ? 100 : 200) withRotation:rotate];
        [self addChild:platform];
    }
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to
{
    return (int)(from + arc4random() % (to-from+1));
}

- (void)createScore {
    self.score = 0;
    self.scoreDisplay = [[SKLabelNode alloc] initWithFontNamed:kCustomFont];
    self.scoreDisplay.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    self.scoreDisplay.fontSize = 20;
    self.scoreDisplay.position = CGPointMake(self.frame.size.width - 30, self.frame.size.height - 30);
    [self addChild:self.scoreDisplay];
}

- (void)playMusic {
    SKAction *playSong = [[SoundPlayer sharedInstance] playMusic:@"My Song.m4a"];
    [self runAction:playSong withKey:@"BGMusic"];
}

- (void)createPauseButton {
    SKButton *pauseButton = [[SKButton alloc] initWithImageNamedNormal:@"Pause" selected:@"PauseSelected"];
    [pauseButton setPosition:CGPointMake(pauseButton.size.width/2, self.frame.size.height - pauseButton.size.height/2)];
    [pauseButton setTouchUpInsideTarget:self action:@selector(togglePause)];
    [self addChild:pauseButton];
}

- (void) togglePause {
    self.scenePaused = !self.scenePaused;
    self.scene.view.paused = self.scenePaused;
}

- (void)gameOver {
    NSLog(@"Game Over");
    [self removeActionForKey:@"BGMusic"];
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    GameOverScene* goScene = [[GameOverScene alloc] initWithSize:self.view.bounds.size andScore:self.score];
    [self.scene.view presentScene: goScene transition: reveal];
}

- (void)checkPlayerBounds {
    
    if (!self.gameOverPending && (self.player.position.x + self.player.size.width/2 < 0 ||
                                  self.player.position.x - self.player.size.width/2 > self.size.width ||
                                  self.player.position.y + self.player.size.height/2 < 0))
    {
        self.gameOverPending = YES;
        [self gameOver];
    }
}

#pragma mark Physics Delegate
-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact: %@",contact);
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & kPlayerProjectileCategory) != 0)
    {
        SKNode *projectile = (contact.bodyA.categoryBitMask & kPlayerProjectileCategory) ? contact.bodyA.node : contact.bodyB.node;
        
        if (secondBody.categoryBitMask & kEnemyCategory) {
            Enemy *enemy = (Enemy*)((contact.bodyA.categoryBitMask & kPlayerProjectileCategory) ?
                                    contact.bodyB.node : contact.bodyA.node);
            
            if ([enemy decrementHealthBy:1]) {
                [enemy runAction:[SKAction removeFromParent]];
                
                //add explosion
                SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[self.explosionTextures objectAtIndex:0]];
                explosion.zPosition = 1;
                explosion.scale = 0.6;
                explosion.position = contact.bodyA.node.position;
                
                [self addChild:explosion];
                
                SKAction *explosionAction = [SKAction animateWithTextures:self.explosionTextures timePerFrame:0.06];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *explosionSound = [[SoundPlayer sharedInstance] playSound:@"explosion.wav"];
                [explosion runAction:[SKAction sequence:@[explosionSound, explosionAction, remove]]];
                
                self.score += 100;
            }
        }
        [projectile runAction:[SKAction removeFromParent]];
    } else if ((firstBody.categoryBitMask & kPlayerCategory) != 0) {
        if (secondBody.categoryBitMask & (kEnemyCategory | kEnemyProjectileCategory |kHazardCategory)) {
            SKNode *player = (contact.bodyA.categoryBitMask & kPlayerCategory) ? contact.bodyA.node : contact.bodyB.node;
            SKNode *enemy = (contact.bodyA.categoryBitMask & kPlayerCategory) ? contact.bodyB.node : contact.bodyA.node;
            [player runAction:[SKAction removeFromParent]];
            [enemy runAction:[SKAction removeFromParent]];
            
            //add explosion
            SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[self.explosionTextures objectAtIndex:0]];
            explosion.zPosition = 1;
            explosion.scale = 0.6;
            explosion.position = contact.bodyA.node.position;
            
            [self addChild:explosion];
            
            SKAction *explosionAction = [SKAction animateWithTextures:self.explosionTextures timePerFrame:0.06];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *explosionSound = [[SoundPlayer sharedInstance] playSound:@"explosion2.wav"];
            [explosion runAction:[SKAction sequence:@[explosionSound, explosionAction,remove]] completion:^(){ [self gameOver]; }];
            
            
        } else if (secondBody.categoryBitMask & kWallCategory) {
            [self.player setGroundContact:YES];
        }
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"End Contact: %@",contact);
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & kPlayerCategory) != 0) {
        if ((secondBody.categoryBitMask & kWallCategory) != 0) {
            [self.player setGroundContact:NO];
        }
        
    }
}


@end
