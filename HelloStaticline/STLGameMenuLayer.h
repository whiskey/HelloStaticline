//
//  STLGameMenuLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 15.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "STLHUDLayer.h"


@interface STLGameMenuLayer : CCLayer<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
@property (nonatomic,retain) id<STLGameHUDDelegate> delegate;
//
@end
