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


@interface STLGameLayer() {
    dispatch_queue_t backgroundQueue;
}
@property (nonatomic,retain) CCTouchDispatcher *touchDispatcher;
@property (nonatomic,retain) NSMutableArray *activeTargets;

- (void) nextFrame:(ccTime)dt;
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
    [scene addChild:hudLayer z:99];
    
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
        backgroundQueue = dispatch_queue_create("de.staticline.gamelayer.bgqueue", NULL);  
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

- (void)dealloc
{
    dispatch_release(backgroundQueue);
    [super dealloc];
}

- (STLPlayer *)player
{
    if (_player) {
        return _player;
    }
    // (re-)initialize player
    self.player = [[[STLPlayer alloc] init] autorelease];    
    // position player node in the center of the screen
    CGSize size = [[CCDirector sharedDirector] winSize];
    _player.node.position =  ccp( size.width /2 , size.height/2 );
    _player.node.zOrder = 5;
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
    _bear.node.zOrder = 0;
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

/*
 the main game loop
 */
- (void)nextFrame:(ccTime)dt
{
    // container for all objects to be removed
    NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
    
    // hit test: player location vs. marker
    for (id<STLTargetProtocol> target in _activeTargets) {
        if (CGRectIntersectsRect(target.node.boundingBox, _player.node.boundingBox)) {
            // target destruction
            [target removeFromGamewithActionType:kSTLTargetExplode];
            // mark as "to delete"
            [targetsToDelete addObject:target];
            
            dispatch_sync(backgroundQueue, ^{
                // player logic (score,achievements,...)
                [_player killedTarget:target];
                // update hud
                [_hud.scoreLabel setString:[NSString stringWithFormat:@"%d",_player.score]];
            });
        }
    }
    
    // quick 'n dirty hit test with the bear
    if (CGRectIntersectsRect(_bear.node.boundingBox, _player.node.boundingBox)) {
        [_bear onPlayerCollision];
    } else if (!_bear.isMoving) {
        // restart bear movement
        [_bear startWalkAnimation];
    }

    // remove objects
    for (id<STLTargetProtocol> target in targetsToDelete) {
        [_activeTargets removeObject:target];
    }
    [targetsToDelete release];
}

#pragma mark - touch handling

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // remove all existing markers
    for (id<STLTargetProtocol> target in _activeTargets) {
        [target removeFromGame];
        [_activeTargets removeObject:target];
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace:touch];
    // start movement
    [_player movePlayerToDestination:location];
    
    // set a marker
    STLMarker *marker = [[STLMarker alloc] init];
    marker.node.position = location;
    [self addChild:marker.node];
    [self.activeTargets addObject:marker];
    [marker release];
}

@end
