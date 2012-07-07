//
//  SLPlayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STLActorProtocol.h"

/*
 Action types for the player
 */
typedef enum {
    kSTLPlayerMovement,         // the movement of the sprite across the screen
    kSTLPlayerWalkAction,       // the walking animation
} STLActorPlayerType;


@interface STLPlayer : NSObject<STLActorProtocol>
@property (nonatomic,readonly) NSUInteger score;
@property (nonatomic,readonly) NSUInteger level;
@property (nonatomic,readonly) NSUInteger lifetimeCatchedMarkers;

// player movement with direction in ... FINDOUT: radians/degrees
- (void) movePlayerToDestination:(CGPoint)destination;

// hit, blased, whatever...
- (void) killedTarget:(id<STLTargetProtocol>)target;

@end
