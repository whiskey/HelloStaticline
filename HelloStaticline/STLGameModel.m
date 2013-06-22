//
//  STLGameModel.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLGameModel.h"

@implementation STLGameModel

+ (STLGameModel *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static STLGameModel *_sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[STLGameModel alloc] init];
        _sharedObject.enemies = [NSMutableArray arrayWithCapacity:20];
        _sharedObject.projectiles = [NSMutableArray arrayWithCapacity:200];
    });
    return _sharedObject;
}

- (void)update:(ccTime)delta
{
    //NSLog(@"projectiles %03d   enemies %03d", _projectiles.count, _enemies.count);
    for (CCSprite *projectile in _projectiles) {
        for (STLEnemy *enemy in _enemies) {
            // FIXME: coordinates
            if (CGRectIntersectsRect(projectile.boundingBox, enemy.node.boundingBox)) {
                DLog(@"enemy hit!");
                [projectile removeFromParentAndCleanup:YES];
                [enemy removeFromGame];
            }
        }
    }
}

@end
