//
//  Constants.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Constants.h"

@implementation Constants

const uint32_t kPlayerCategory = 0x1 << 0;
const uint32_t kPlayerProjectileCategory = 0x1 << 1;
const uint32_t kEnemyCategory = 0x1 << 2;
const uint32_t kEnemyProjectileCategory = 0x1 << 3;
const uint32_t kWallCategory = 0x1 << 4;
const uint32_t kHazardCategory = 0x1 << 5;

NSString* const kCustomFont = @"8BITWONDERNominal";

const float BG_VELOCITY = 100.0;
const float kXDeletePoint = -100;
@end
