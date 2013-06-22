//
//  STLBear.h
//  HelloStaticline
//
//  The bear is kidnapped from Ray Wenderlich's demo. For more informations see:
//  http://www.raywenderlich.com/1271/how-to-use-animations-and-sprite-sheets-in-cocos2d
//
//  - no other pets have been harmed during the coding of this game -
//
//  Created by Carsten Witzke on 05.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLBaseSprite.h"

/*
 Action types for the bear
 */
typedef enum {
    kSTLBearActionMovement,
    kSTLBearActionHide,
} STLBearAction;


@interface STLBear : STLBaseSprite

@property (assign,getter = isMoving) BOOL moving;

- (void)onPlayerCollision;

// might become private later
- (void)startWalkAnimation;
- (void)stopWalkAnimation;

@end
