//
//  STLEnemy.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLEnemy.h"
#import "STLGameModel.h"

@interface STLEnemy ()
@property (nonatomic, strong) STLGameModel *gameModel;

@end

@implementation STLEnemy
@synthesize node = _node;
@synthesize sprite = _sprite;
@synthesize pointValue = _pointValue;

- (id)init
{
    self = [super init];
    if (self) {
        self.gameModel = [STLGameModel sharedInstance];
    }
    return self;
}

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

#pragma mark - STLTargetProtocol

- (void)removeFromGame
{
    [self removeFromGamewithActionType:kSTLTargetDisappearWithNoAction];
}

- (void)removeFromGamewithActionType:(STLTargetRemovalType)type
{
    switch (type) {
        case kSTLTargetExplode:
            [self removeFromGame];
            break;
        default:
            [_node removeFromParentAndCleanup:YES];
            break;
    }
    [_gameModel.enemies removeObject:self];
}

@end
