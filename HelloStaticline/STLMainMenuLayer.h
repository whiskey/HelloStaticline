//
//  HelloWorldLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright staticline 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface STLMainMenuLayer : CCLayer<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>

// returns a CCScene that contains the STLMainMenuLayer as the only child
+(CCScene *) scene;

@end
