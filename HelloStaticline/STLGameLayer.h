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
#import "STLWorldLayer.h"
#import "STLGameModel.h"
#import "STLPlayer.h"
#import "STLBear.h"
#import "STLEnemy.h"

@interface STLGameLayer : CCLayer<CCTargetedTouchDelegate,STLGameHUDDelegate>
@property (strong, nonatomic) STLGameModel *gameModel;

@property (strong, nonatomic) CCSpriteBatchNode *batchNode;
@property (strong, nonatomic) STLWorldLayer *world;
@property (strong, nonatomic) STLHUDLayer *hud;



+(CCScene *) scene;

@end
