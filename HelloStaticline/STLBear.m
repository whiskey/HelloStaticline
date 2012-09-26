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
@synthesize node = _node;
@synthesize sprite = _sprite;
@synthesize walkAction = _walkAction;
@synthesize moveAction = _moveAction;
@synthesize moving = _moving;

- (void)dealloc
{
    self.sprite = nil;
    self.walkAction = nil;
    self.moveAction = nil;
    [super dealloc];
}

- (CCNode *)node
{
    if (_node) {
        return _node;
    }
    // init with spritesheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear_sprite_default.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bear_sprite_default.png"];
    _node = [CCNode node];
    [_node addChild:spriteSheet];
    // standing still
    _sprite = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
    // scaling - better: use hd sprites
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        [_sprite setScale:1.0f];
    } else {
        [_sprite setScale:0.5f];
    }
    [spriteSheet addChild:_sprite];
    _node.contentSize = _sprite.contentSize;
    return _node;
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
    [_sprite runAction:_walkAction];
    _moving = YES;
}

- (void)stopWalkAnimation
{
    [_sprite stopActionByTag:kSTLBearActionMovement];
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
