//
//  SoundPlayer.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "SoundPlayer.h"

@interface SoundPlayer()

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
    
    return self;
}

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

- (SKAction*)playSound:(NSString*)fileName {
    if (self.soundEffectsEnabled) {
        return [SKAction playSoundFileNamed:fileName waitForCompletion:NO];
    }
    return [SKAction waitForDuration:0];
}

- (SKAction*)playMusic:(NSString*)fileName {
    if (self.musicEnabled) {
        SKAction *playSong = [SKAction playSoundFileNamed:fileName waitForCompletion:YES];
        return [SKAction repeatActionForever:playSong];
    } else {
        return [SKAction waitForDuration:0];
    }
    
}

@end
