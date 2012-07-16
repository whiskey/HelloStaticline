//
//  STLHUDLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 03.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*
 HUD delegate
 */
@protocol STLGameHUDDelegate <NSObject>
- (BOOL)toggleGamePause;
- (BOOL)toogleBackgroundMusic;
@end


/*
 The main HUD
 */
@interface STLHUDLayer : CCLayer
@property (nonatomic,retain) id<STLGameHUDDelegate> delegate;
@property (nonatomic,retain) CCLabelAtlas *scoreLabel;

- (void) showConversation:(NSInteger)cID;

@end
