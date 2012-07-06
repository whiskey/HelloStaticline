//
//  STLBear.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 05.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLBear.h"

@interface STLBear ()

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
    [_sprite setScale:0.5f];
    [spriteSheet addChild:self.sprite];
    
    return _node;
}

- (void)onPlayerCollision
{
    if (_moving) {
        // hide from evil player
        [self stopWalkAnimation];
    }
}

#pragma mark - actions

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
