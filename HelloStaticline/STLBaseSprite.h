//
//  STLBaseSprite.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

//#import "STLGameModel.h"
//@class STLGameModel;

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
@protocol STLTargetProtocol <NSObject>
- (void) removeFromGame;
- (void) removeFromGamewithActionType:(STLTargetRemovalType)type;
@end


@interface STLBaseSprite : NSObject
@property (strong, nonatomic) CCSprite *sprite;
//@property (strong, nonatomic) STLGameModel *gameModel;
@property (assign, nonatomic) NSUInteger pointValue;
@end
