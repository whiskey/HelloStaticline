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

- (void)spawnActors;
- (void)nextFrame:(ccTime)dt;
- (void)setViewpointCenter:(CGPoint) position;
@end


@implementation STLGameLayer
@synthesize world = _world;
@synthesize hud = _hud;
@synthesize activeTargets = _activeTargets;
@synthesize player = _player;
@synthesize bear = _bear;
@synthesize touchDispatcher = _touchDispatcher;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    // the world
    STLWorldLayer *world = [STLWorldLayer node];
    [scene addChild:world z:-1];
    
    // the hud
    STLHUDLayer *hudLayer = [STLHUDLayer node];
    [scene addChild:hudLayer z:99];
    
    // the game
    STLGameLayer *gameLayer = [STLGameLayer node];
    // set properties
    gameLayer.world = world;
    gameLayer.hud = hudLayer;
    [scene addChild:gameLayer];
    
    // moved some stuff out of the gameLayer init into this function
    [gameLayer spawnActors];
    
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
        
        // set scheduler
        [self schedule:@selector(nextFrame:)];
        
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(backgroundQueue);
    [super dealloc];
}

- (void)spawnActors
{
    // add player
    self.player.node.position = [_world playerSpawnPoint];
    [self addChild:_player.node];
    
    // add bear - the other good guy in game
    self.bear.node.position = [_world bearSpawnPoint];
    [self addChild:_bear.node];

    // center on player
    [self setViewpointCenter:_player.node.position];
}

- (STLPlayer *)player
{
    if (_player) {
        return _player;
    }
    // (re-)initialize player
    self.player = [[[STLPlayer alloc] init] autorelease];
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
    
    [self setViewpointCenter:_player.node.position];
}

/*
 Sets the view focus on the player
 */
- (void)setViewpointCenter:(CGPoint)position
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_world.tileMap.mapSize.width * _world.tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (_world.tileMap.mapSize.height * _world.tileMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    _world.position = viewPoint;
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
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    // check movement contraints (walls, etc.) on target
    CGPoint tileCoord = [_world tileCoordForPosition:touchLocation];
    int tileGid = [_world.meta tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [_world.tileMap propertiesForGID:tileGid];
        if (properties) {
            NSString *collision = [properties valueForKey:@"collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                NSLog(@"no movement to this position");
                return;
            }
        }
    }
    // check in between
    CGPoint movementVector = ccpSub(_player.node.position, touchLocation);
    // TODO: find intermediate collisions
    // TODO: implement way-finding
    
    
    // move player to touched location
    [_player movePlayerToDestination:touchLocation];
    
    // set a marker
    STLMarker *marker = [[STLMarker alloc] init];
    marker.node.position = touchLocation;
    [self addChild:marker.node];
    [self.activeTargets addObject:marker];
    [marker release];
}

@end
