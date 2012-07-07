//
//  STLMarker.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLMarker.h"

@interface STLMarker()
//
@end

@implementation STLMarker
@synthesize node = _node;
@synthesize sprite = _sprite;
@synthesize pointValue = _pointValue;

- (id)init
{
    self = [super init];
    if (self) {
        // marker has point values between 5 and 50 in steps of 5
        _pointValue = (arc4random() % 10 + 1) * 5;
    }
    return self;
}

- (CCNode *)node
{
    if (_node) {
        return _node;
    }
    // init with simple sprite
    _node = [CCNode node];
    _sprite = [CCSprite spriteWithFile:@"marker_cross.png"];
    // scaling - better: use hd sprites
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        [_sprite setScale:1.0f];
    } else {
        [_sprite setScale:0.5f];
    }
    [_node addChild:_sprite];
    _node.contentSize = _sprite.contentSize;
    return _node;
}

#pragma mark - ui actions
- (void)removeFromGame
{
    [self removeFromGamewithActionType:kSTLTargetDisappearWithNoAction];
}

- (void)removeFromGamewithActionType:(STLTargetRemovalType)type
{
    switch (type) {
        case kSTLTargetDisappearWithNoAction:
        {
            // simply remove
            [_node removeFromParentAndCleanup:YES];
            break;
        }
        case kSTLTargetExplode:
        {
            // explosion, well... kinda...
            id action1 = [CCScaleTo actionWithDuration:0.8f scale:0.3f];
            id scale = [CCEaseBackInOut actionWithAction:action1];
            
            id action2 = [CCFadeOut actionWithDuration:1.0f];
            id fadeOut = [CCEaseOut actionWithAction:action2];
            
            id remove = [CCCallBlock actionWithBlock:^{
                [_node removeFromParentAndCleanup:YES];
            }];
            
            id spawn = [CCSpawn actions:scale,fadeOut, nil];
            id sequence = [CCSequence actions:spawn, remove, nil];
            
            [_sprite runAction:sequence];
            break;
        }
        default:
        {
            NSString *msg = [NSString stringWithFormat:@"unsupported STLMarkerActionType %d",type];
            [NSException exceptionWithName:@"STLMarkerActionTypeUnsupportedException" 
                                    reason:NSLocalizedString(msg, @"STLMarkerActionTypeUnsupportedException") 
                                  userInfo:nil];
        }
    }
}
@end
