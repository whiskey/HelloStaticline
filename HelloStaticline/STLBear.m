//
//  STLBear.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 05.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLBear.h"


@implementation STLBear
@synthesize node = _node;
@synthesize sprite = _sprite;
@synthesize walkAction = _walkAction;
@synthesize moveAction = _moveAction;

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

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
    
    // frames
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"bear%d.png", i]]];
    }

    // TODO: define walk+move actions
//    // animation
//    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
//    // create sprite and go
//    _sprite = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
//    self.walkAction = [CCRepeatForever actionWithAction:
//                       [CCAnimate actionWithAnimation:walkAnim]];
//    [_sprite runAction:_walkAction];
//    [spriteSheet addChild:_sprite];
    
    return _node;
}

@end
