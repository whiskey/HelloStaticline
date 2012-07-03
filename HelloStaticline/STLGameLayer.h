//
//  SLGameLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STLHUDLayer.h"
#import "STLPlayer.h"

/*
 Action types for the player
 */
typedef enum {
    kSTLPlayerMovement,
} STLActorPlayerType;


/*
 Action types for Markers
 */
typedef enum {
    kSTLMarkerDisappear,
    kSTLMarkerExplode,
} STLMarkerActionType;


@interface STLGameLayer : CCLayer<CCTargetedTouchDelegate>
@property (nonatomic,retain) STLHUDLayer *hud;
@property (nonatomic,retain) STLPlayer *player;

+(CCScene *) scene;

@end
