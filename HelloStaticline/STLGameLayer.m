//
//  SLGameLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLGameLayer.h"
#import "CCTouchDispatcher.h"
#import "STLMarker.h"

// maybe I'll find a shorter day later...
NSString * const kSTLMarkerActionTypeUnsupportedException = @"STLMarkerActionTypeUnsupportedException";


@interface STLGameLayer()
@property (nonatomic,retain) CCTouchDispatcher *touchDispatcher;
@property (nonatomic,retain) NSMutableArray *markers;

- (void) nextFrame:(ccTime)dt;

- (void) destroyTarget:(id<STLTargetProtocol>)target;
- (void) destroyTarget:(id<STLTargetProtocol>)target withActionType:(STLMarkerActionType)type;
@end


@implementation STLGameLayer
@synthesize markers = _markers;
@synthesize player = _player;
@synthesize touchDispatcher = _touchDispatcher;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    STLGameLayer *gameLayer = [STLGameLayer node];
    [scene addChild:gameLayer];
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        // settings
        self.isTouchEnabled = YES;
        self.markers = [NSMutableArray arrayWithCapacity:1];
        // add player
        [self addChild:self.player.node];
        // schedule and go
        [self schedule:@selector(nextFrame:)];
    }
    return self;
}

- (STLPlayer *)player
{
    if (_player) {
        return _player;
    }
    // (re-)initialize player
    self.player = [[STLPlayer alloc] init];
    // position player node in the center of the screen
    [_player setNode:[CCSprite spriteWithFile:@"player.png"]];
    CGSize size = [[CCDirector sharedDirector] winSize];
    _player.node.position =  ccp( size.width /2 , size.height/2 );
    return _player;
}

- (CCTouchDispatcher *)touchDispatcher
{
    if (_touchDispatcher) {
        return _touchDispatcher;
    }
    self.touchDispatcher = [[CCDirector sharedDirector] touchDispatcher];
    return _touchDispatcher;
}

- (void)registerWithTouchDispatcher
{
    // CCTouchDispatcher is no longer singleton!
    [self.touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)nextFrame:(ccTime)dt
{
    // hit test: player location vs. marker
    for (STLMarker *marker in self.markers) {
        if (CGRectIntersectsRect(marker.node.boundingBox, _player.node.boundingBox)) {
            [self destroyTarget:marker withActionType:kSTLMarkerExplode];
        }
    }
}

#pragma mark - touch handling

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // remove all existing markers
    for (CCNode *child in self.children) {
        if (child != _player.node) {
            [self removeChild:child cleanup:YES];
        }
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace:touch];

    // stop movement
    [_player.node stopActionByTag:kSTLPlayerMovement];
    
    // create movement with ease in/out
    id movement = [CCMoveTo actionWithDuration:2.0f position:location];
    [movement setTag:kSTLPlayerMovement];
    id ease = [CCEaseInOut actionWithAction:movement rate:2.0f];
    [_player.node runAction:ease];
    
    // set a marker
    STLMarker *marker = [[STLMarker alloc] init];
    marker.node = [CCSprite spriteWithFile:@"marker_cross.png"];
    marker.node.position = location;
    [self addChild:marker.node];
    [self.markers addObject:marker];
    [marker release];
}

#pragma mark - actor actions

- (void)destroyTarget:(id<STLTargetProtocol>)target
{
    [self destroyTarget:target withActionType:kSTLMarkerDisappear];
}

- (void)destroyTarget:(id<STLTargetProtocol>)target withActionType:(STLMarkerActionType)type
{
    switch (type) {
        case kSTLMarkerDisappear:
        {
            // simply remove
            [self removeChild:target cleanup:YES];
            break;
        }
        case kSTLMarkerExplode:
        {
            // explosion, well... kinda...
            NSLog(@"BOOOM!");
            NSLog(@"point value %d",target.pointValue);
            [self removeChild:target cleanup:YES];
            break;
        }
        default:
        {
            NSString *msg = [NSString stringWithFormat:@"unsupported STLMarkerActionType %d",type];
            [NSException exceptionWithName:kSTLMarkerActionTypeUnsupportedException 
                                    reason:NSLocalizedString(msg, kSTLMarkerActionTypeUnsupportedException) 
                                  userInfo:nil];
            break;
        }
    }
    [_markers removeObject:target];
}

@end
