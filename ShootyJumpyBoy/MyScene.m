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
@property (strong, nonatomic) NSMutableArray *runTextures;

@property (strong, nonatomic) SKSpriteNode *floor;

@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) NSTimeInterval lastUpdateTime;

@property (strong, nonatomic) NSMutableArray *explosionTextures;

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) SKLabelNode *scoreDisplay;

@property (nonatomic) BOOL scenePaused;

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
        
        SKAction *updateEnimies = [SKAction sequence:@[wait, callEnemies]];
        [self runAction:[SKAction repeatActionForever:updateEnimies]];
        
        self.scenePaused = NO;

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
    self.scoreDisplay.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    
    [self moveBg];
}

- (void)createPlayer {
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Shoot"];
    self.player.name = @"player";
    [self.player setScale:0.2];
    
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.categoryBitMask = kPlayerCategory;
    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.contactTestBitMask = kEnemyCategory | kEnemyProjectileCategory;
    self.player.physicsBody.collisionBitMask = kWallCategory;
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
    self.floor = [SKSpriteNode spriteNodeWithImageNamed:@"Floor"];
    [self.floor setScale:0.45];
    self.floor.name = @"floor";
    
    self.floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.floor.size];
    self.floor.physicsBody.categoryBitMask = kWallCategory;
    self.floor.physicsBody.dynamic = NO;
    self.floor.position = CGPointMake(self.frame.size.width/2, 0);
    
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
    [self.player.physicsBody applyImpulse:CGVectorMake(0, 30.0) atPoint:self.player.position];
}

- (void)shootFromNode:(SKSpriteNode*)node {
    CGPoint location = [node position];
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"spark"];
    
    bullet.position = CGPointMake(location.x + node.size.width/2, location.y);
    bullet.scale = 0.5;
    
    bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.height/5];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = kPlayerProjectileCategory; //TODO
    bullet.physicsBody.contactTestBitMask = kEnemyCategory;
    bullet.physicsBody.collisionBitMask = 0;
    
    SKAction *fire = [SKAction moveToX:self.frame.size.width + bullet.size.width duration:2];
    SKAction *remove = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[fire, remove]]];
    
    
    NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"Projectile" ofType:
                           @"sks"];
    SKEmitterNode *projectileEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    //projectileEmitter.position = bullet.position;
    [bullet addChild:projectileEmitter];
    
    [self addChild:bullet];
}

- (void)generateEnemies
{
    if ([self getRandomNumberBetween:0 to:1] == 1) {
        SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"Met"];
        enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
        [enemy setScale:0.1];
        
        enemy.physicsBody.dynamic = YES;
        enemy.physicsBody.categoryBitMask = kEnemyCategory;
        enemy.physicsBody.contactTestBitMask = kPlayerCategory | kPlayerProjectileCategory;
        enemy.physicsBody.collisionBitMask = kWallCategory;
        
        enemy.position = CGPointMake(self.frame.size.width, 260);
        SKAction *moveEnemy = [SKAction moveToX:0 duration:2];
        
        [self addChild:enemy];
        [enemy runAction:[SKAction sequence:@[moveEnemy, [SKAction removeFromParent]]]];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to
{
    return (int)(from + arc4random() % (to-from+1));
}

- (void)createScore {
    self.score = 0;
    self.scoreDisplay = [[SKLabelNode alloc] initWithFontNamed:@"Copperplate"];
    self.scoreDisplay.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    self.scoreDisplay.fontSize = 30;
    self.scoreDisplay.position = CGPointMake(self.frame.size.width, self.frame.size.height - 30);
    [self addChild:self.scoreDisplay];
}

- (void)playMusic {
    SKAction *playSong = [SKAction playSoundFileNamed:@"My Song.m4a" waitForCompletion:YES];
    [self runAction:[SKAction repeatActionForever:playSong] withKey:@"BGMusic"];
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
        SKNode *enemy = (contact.bodyA.categoryBitMask & kPlayerProjectileCategory) ? contact.bodyB.node : contact.bodyA.node;
        [projectile runAction:[SKAction removeFromParent]];
        [enemy runAction:[SKAction removeFromParent]];
        
        //add explosion
        SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[self.explosionTextures objectAtIndex:0]];
        explosion.zPosition = 1;
        explosion.scale = 0.6;
        explosion.position = contact.bodyA.node.position;
        
        [self addChild:explosion];
        
        SKAction *explosionAction = [SKAction animateWithTextures:self.explosionTextures timePerFrame:0.06];
        SKAction *remove = [SKAction removeFromParent];
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
        
        self.score += 10;
    } else if ((firstBody.categoryBitMask & kPlayerCategory) != 0) {
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
        [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
        
        NSLog(@"Game Over");
        [self removeActionForKey:@"BGMusic"];
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
        GameOverScene* goScene = [[GameOverScene alloc] initWithSize:self.view.bounds.size andScore:self.score];
        [self.scene.view presentScene: goScene transition: reveal];
    }

}


@end
