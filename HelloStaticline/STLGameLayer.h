//
//  SLGameLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STLWorldLayer.h"
#import "STLHUDLayer.h"
#import "STLPlayer.h"
#import "STLBear.h"

@interface STLGameLayer : CCLayer<CCTargetedTouchDelegate,STLGameHUDDelegate>
@property (nonatomic,retain) STLWorldLayer *world;
@property (nonatomic,retain) STLHUDLayer *hud;

@property (nonatomic,retain) STLPlayer *player;
@property (nonatomic,retain) STLBear *bear;

+(CCScene *) scene;

@end
