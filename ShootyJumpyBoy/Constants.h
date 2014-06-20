//
//  Constants.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

FOUNDATION_EXPORT const uint32_t kPlayerCategory;
FOUNDATION_EXPORT const uint32_t kPlayerProjectileCategory;
FOUNDATION_EXPORT const uint32_t kEnemyCategory;
FOUNDATION_EXPORT const uint32_t kEnemyProjectileCategory;
FOUNDATION_EXPORT const uint32_t kWallCategory;
FOUNDATION_EXPORT const uint32_t kHazardCategory;

FOUNDATION_EXPORT const uint32_t kExplosionSound;
FOUNDATION_EXPORT const uint32_t kExplosion2Sound;
FOUNDATION_EXPORT const uint32_t kHitSound;
FOUNDATION_EXPORT const uint32_t kJumpSound;
FOUNDATION_EXPORT const uint32_t kLaserSound;
FOUNDATION_EXPORT const uint32_t kPickupSound;
FOUNDATION_EXPORT const uint32_t kPowerupSound;
FOUNDATION_EXPORT const uint32_t kSelectSound;

FOUNDATION_EXPORT NSString * const kCustomFont;

FOUNDATION_EXPORT const float BG_VELOCITY;
FOUNDATION_EXPORT const float kXDeletePoint;

@end
