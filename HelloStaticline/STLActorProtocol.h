//
//  STLActorProtocol.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*********************************************************************************/

/*
 General actor protocol for all gaming objects visible on the screen, like
 the player or all targets.
 */
@protocol STLActorProtocol <NSObject>
// ui
@property (nonatomic,assign) CCNode* node;
@property (nonatomic,assign) CCSprite *sprite;

@end

/*********************************************************************************/

/*
 Some ways a target may disappear from screen.
 */
typedef enum {
    kSTLTargetDisappearWithNoAction,
    kSTLTargetExplode,
} STLTargetRemovalType;

/*
 A target protocol
 */
@protocol STLTargetProtocol <STLActorProtocol>
@property (nonatomic,assign) NSUInteger pointValue;

- (void) removeFromGame;
- (void) removeFromGamewithActionType:(STLTargetRemovalType)type;
@end
