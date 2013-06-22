//
//  STLEnemy.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLEnemy.h"

@implementation STLEnemy
@synthesize node = _node;
@synthesize sprite = _sprite;


- (CCNode *)node
{
    if (_node) {
        return _node;
    }
    // init with spritesheet
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"atlas.pvr.ccz"];
    _node = [CCNode node];
    [_node addChild:spriteSheet];
    // standing still
    _sprite = [CCSprite spriteWithSpriteFrameName:@"enemy_u_01.png"];
    [spriteSheet addChild:_sprite];
    _node.contentSize = _sprite.contentSize;
    return _node;
}

- (void)onPlayerCollision
{
    DLog(@"collision");
}

@end
