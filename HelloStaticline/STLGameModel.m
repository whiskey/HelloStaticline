//
//  STLGameModel.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLGameModel.h"
#import "STLMarker.h"

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
#warning this is broken...
            // game_layer
            //   |
            //   |-> player
            //   |      |
            //   |      |-> batch_node
            //   |              |
            //   |              |-> projectile
            //   |
            //   |-> batch_node
            //           |
            //           |-> enemy
            
            CGPoint shot = [projectile convertToWorldSpace:projectile.position];
            CGPoint target = [enemy.sprite convertToWorldSpaceAR:enemy.sprite.position];
            
            float distance = pow(shot.x - target.x, 2) + pow(shot.y - target.y, 2);
            distance = sqrt(distance);
            
            DLog(@"%@ %@ dist: %.4f",NSStringFromCGPoint(shot), NSStringFromCGPoint(target), distance);
            
//            STLMarker *marker = [[STLMarker alloc] init];
//            marker.node.position = ball;
//            [projectile addChild:marker.node];
            
            
//            if (CGRectContainsPoint(enemy.node.boundingBox, ball)) { //CGRectIntersectsRect(projectile.boundingBox, enemy.node.boundingBox)
//                DLog(@"enemy hit!");
//                [projectile removeFromParentAndCleanup:YES];
//                [enemy removeFromGame];
//            }
        }
    }
}

@end

