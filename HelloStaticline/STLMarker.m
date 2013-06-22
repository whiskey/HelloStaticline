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

- (id)init
{
    self = [super init];
    if (self) {
        self.sprite = [CCSprite spriteWithSpriteFrameName:@"marker.png"];
        
        // marker has point values between 5 and 50 in steps of 5
        self.pointValue = (arc4random() % 10 + 1) * 5;
    }
    return self;
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
            [self.sprite removeFromParentAndCleanup:YES];
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
                [self.sprite removeFromParentAndCleanup:YES];
            }];
            
            id spawn = [CCSpawn actions:scale,fadeOut, nil];
            id sequence = [CCSequence actions:spawn, remove, nil];
            
            [self.sprite runAction:sequence];
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
