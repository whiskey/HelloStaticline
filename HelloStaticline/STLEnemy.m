//
//  STLEnemy.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLEnemy.h"
#import "STLGameModel.h"


@implementation STLEnemy

- (id)init
{
    self = [super init];
    if (self) {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"enemy_u_01.png"];
    }
    return self;
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
            [self.sprite removeFromParentAndCleanup:YES];
            break;
    }
    [[STLGameModel sharedInstance].enemies removeObject:self];
}

@end
