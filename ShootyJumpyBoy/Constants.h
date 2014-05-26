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

FOUNDATION_EXPORT const float BG_VELOCITY;
/*
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
 */
@end
