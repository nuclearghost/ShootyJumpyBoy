//
//  Hazard.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/19/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Constants.h"

@interface Hazard : SKSpriteNode

- (id)initHazardOfType:(uint32_t)type AtPoint: (CGPoint)point;


@end
