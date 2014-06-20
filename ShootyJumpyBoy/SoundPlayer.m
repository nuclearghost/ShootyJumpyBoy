//
//  SoundPlayer.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "SoundPlayer.h"

@interface SoundPlayer()

@property (strong, nonatomic) NSMutableDictionary *soundsDict;

@property (nonatomic) BOOL soundEffectsEnabled;
@property (nonatomic) BOOL musicEnabled;

@end

@implementation SoundPlayer

static SoundPlayer *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[SoundPlayer alloc] init];
}

- (id)mutableCopy
{
    return [[SoundPlayer alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    
    self.soundEffectsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound_effects"];
    self.musicEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"sound_effects"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"music"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager]prepareToPlayWithSound:@"hit.wav"];

    return self;
}

- (void)initializeSoundDictioanry {
    self.soundsDict = [[NSMutableDictionary alloc] initWithCapacity:8];
    [self.soundsDict setObject:[Sound soundNamed:@"explosion.wav"]
                        forKey:[NSNumber numberWithInt: kExplosionSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"explosion2.wav"]
                        forKey:[NSNumber numberWithInt: kExplosion2Sound]];
    [self.soundsDict setObject:[Sound soundNamed:@"hit.wav"]
                        forKey:[NSNumber numberWithInt: kHitSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"jump.wav"]
                        forKey:[NSNumber numberWithInt: kJumpSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"laser.wav"]
                        forKey:[NSNumber numberWithInt: kLaserSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"pickup.wav"]
                        forKey:[NSNumber numberWithInt: kPickupSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"powerup.wav"]
                        forKey:[NSNumber numberWithInt: kPowerupSound]];
    [self.soundsDict setObject:[Sound soundNamed:@"select.wav"]
                        forKey:[NSNumber numberWithInt: kSelectSound]];
}

/**
 *  KVO to observe when NSUserDefaults changes
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"sound_effects"]) {
        self.soundEffectsEnabled = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    } else if ([keyPath isEqual:@"music"]) {
        self.musicEnabled = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    }
}

/**
 *  Play a sound if option enabled
 *
 *  @param fileName file to play
 *
 *  @return SKAction* which should then be performed
 */
- (void)playSound:(NSString*)fileName {
    if (self.soundEffectsEnabled) {
        [[SoundManager sharedManager] playSound:fileName];
    }
}

- (void)playSoundWithId:(uint32_t)soundId {
    if (self.soundEffectsEnabled) {
        [[SoundManager sharedManager]
         playSound:[self.soundsDict objectForKey:[NSNumber numberWithInt:soundId]]];
    }
}

- (SKAction*)getSoundActionFromFile:(NSString *)fileName {
    if (self.soundEffectsEnabled) {
        return [SKAction playSoundFileNamed:fileName waitForCompletion:NO];
    }  else {
        return [SKAction waitForDuration:0];
    }
}

/**
 *  Play background music if setting enabled
 *
 *  @param fileName file to play
 *
 *  @return SKAction* which should then be performed
 */
- (void)playMusic:(NSString*)fileName {
    if (self.musicEnabled) {
        [[SoundManager sharedManager] playMusic:fileName looping:YES fadeIn:NO];
    }
}

/**
 *  Stop all currently playing sounds and music
 */
- (void)stopSoundsAndMusic {
    [[SoundManager sharedManager] stopAllSounds];
    [[SoundManager sharedManager] stopMusic];
}

@end
