//
//  STLBear.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 05.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLBear.h"
#import "STLGameCenterManager.h"

@interface STLBear ()
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

@end

@implementation STLBear
@synthesize walkAction = _walkAction;
@synthesize moveAction = _moveAction;
@synthesize moving = _moving;

- (id)init
{
    self = [super init];
    if (self) {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
    }
    return self;
}

#pragma mark - gameplay

- (void)onPlayerCollision
{
    if (_moving) {
        // hide from evil player
        [self stopWalkAnimation];
    }
    // TODO: check if already reported
    [[STLGameCenterManager sharedInstance] reportAchievementIdentifier:kSTLAchievementFindBear
                                                       percentComplete:100.0f];
}

#pragma mark - ui actions

- (void)startWalkAnimation
{
    self.walkAction.tag = kSTLBearActionMovement;
    [self.sprite runAction:_walkAction];
    _moving = YES;
}

- (void)stopWalkAnimation
{
    [self.sprite stopActionByTag:kSTLBearActionMovement];
    _moving = NO;
}

- (CCAction *)walkAction
{
    if (_walkAction) {
        return _walkAction;
    }
    // frames
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"bear%d.png", i]]];
    }
    // animation
    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];    
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    return _walkAction;
}

@end
