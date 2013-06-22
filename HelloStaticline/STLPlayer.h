//
//  SLPlayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLBaseSprite.h"

/*
 Action types for the player
 */
typedef enum {
    kSTLPlayerMovement,         // the movement of the sprite across the screen
    kSTLPlayerWalkAction,       // the walking animation
} STLActorPlayerType;


@interface STLPlayer : STLBaseSprite

// player movement with direction in ... FINDOUT: radians/degrees
- (void) movePlayerToDestination:(CGPoint)destination;

- (void) shootToDirection:(CGPoint)direction;

// hit, blased, whatever...
- (void) killedTarget:(id<STLTargetProtocol>)target;

@end
