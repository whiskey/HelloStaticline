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
@property (nonatomic,retain) NSMutableArray *activeTargets;

- (void) nextFrame:(ccTime)dt;

- (void) destroyTarget:(id<STLTargetProtocol>)target;
- (void) destroyTarget:(id<STLTargetProtocol>)target withActionType:(STLMarkerActionType)type;
@end


@implementation STLGameLayer
@synthesize hud = _hud;
@synthesize activeTargets = _activeTargets;
@synthesize player = _player;
@synthesize bear = _bear;
@synthesize touchDispatcher = _touchDispatcher;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    // the hud
    STLHUDLayer *hudLayer = [STLHUDLayer node];
    [scene addChild:hudLayer z:1];
    
    // the game
    STLGameLayer *gameLayer = [STLGameLayer node];
    gameLayer.hud = hudLayer;
    [scene addChild:gameLayer];
    
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        // settings
        self.isTouchEnabled = YES;
        self.activeTargets = [NSMutableArray arrayWithCapacity:1];
        
        // add player
        [self addChild:self.player.node];
        // bear - some kind of oppenent
        [self addChild:self.bear.node];
        
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
    self.player = [[[STLPlayer alloc] init] autorelease];
    // load sprite
    CCSprite *playerSprite = nil;
#pragma message "TODO: retina/non-retina sprite"
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        playerSprite = [CCSprite spriteWithFile:@"player.png"];
    } else {
        playerSprite = [CCSprite spriteWithFile:@"player.png"];
    }
    [_player setNode:playerSprite];
    
    // position player node in the center of the screen
    CGSize size = [[CCDirector sharedDirector] winSize];
    _player.node.position =  ccp( size.width /2 , size.height/2 );
    
    return _player;
}

- (STLBear *)bear
{
    if (_bear) {
        return _bear;
    }
    self.bear = [[[STLBear alloc] init] autorelease];
    CGSize size = [[CCDirector sharedDirector] winSize];
    // set him to the lower right corner
    _bear.node.position =  ccp( size.width * 0.7 , size.height * 0.3 );
    // walking around (atm, just animation)
    [_bear startWalkAnimation];
    return _bear;
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
    for (id<STLTargetProtocol> target in _activeTargets) {
        if (CGRectIntersectsRect(target.node.boundingBox, _player.node.boundingBox)) {
            [self destroyTarget:target withActionType:kSTLMarkerExplode];
        }
    }
    // quick 'n dirty hit test with the bear
    if (CGRectIntersectsRect(_bear.node.boundingBox, _player.node.boundingBox)) {
        [_bear onPlayerCollision];
    } else if (!_bear.isMoving) {
        // restart bear movement
        [_bear startWalkAnimation];
    }
}

#pragma mark - touch handling

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // remove all existing markers
    for (id<STLTargetProtocol> target in _activeTargets) {
        [self destroyTarget:target];
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
    [self.activeTargets addObject:marker];
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
            [self removeChild:target.node cleanup:YES];
            break;
        }
        case kSTLMarkerExplode:
        {
            // explosion, well... kinda...
            id action1 = [CCScaleTo actionWithDuration:0.8f scale:0.3f];
            id scale = [CCEaseBackInOut actionWithAction:action1];
            
            id action2 = [CCFadeOut actionWithDuration:1.0f];
            id fadeOut = [CCEaseOut actionWithAction:action2];
            
            id remove = [CCCallBlock actionWithBlock:^{
                [self removeChild:target.node cleanup:YES];
            }];
            
            id spawn = [CCSpawn actions:scale,fadeOut, nil];
            id sequence = [CCSequence actions:spawn, remove, nil];
            
            [target.node runAction:sequence];
            break;
        }
        default:
        {
            NSString *msg = [NSString stringWithFormat:@"unsupported STLMarkerActionType %d",type];
            [NSException exceptionWithName:kSTLMarkerActionTypeUnsupportedException 
                                    reason:NSLocalizedString(msg, kSTLMarkerActionTypeUnsupportedException) 
                                  userInfo:nil];
        }
    }
    // player logic (score,achievements,...)
    [_player killedTarget:target];
    // cleanup, remove from array
    [_activeTargets removeObject:target];
    // update hud
    [_hud.scoreLabel setString:[NSString stringWithFormat:@"%d",_player.score]];
}

@end
