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
#import "SimpleAudioEngine.h"

#define BACKGROUND_MUSIC_FILE @"BackgroundMusic.aifc"

@interface STLGameLayer() {
    dispatch_queue_t backgroundQueue;
    BOOL isPaused;
}
@property (nonatomic,retain) CCTouchDispatcher *touchDispatcher;
@property (nonatomic,retain) NSMutableArray *activeTargets;

- (void)spawnActors;
- (void)initAudio;
- (void)nextFrame:(ccTime)dt;
- (void)setViewpointCenter:(CGPoint) position;
@end


@implementation STLGameLayer
@synthesize world = _world;
@synthesize hud = _hud;
@synthesize activeTargets = _activeTargets;
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
    // set delegates
    gameLayer.hud.delegate = gameLayer;
    
    [scene addChild:gameLayer];
    
    // moved some stuff out of the gameLayer init into this function
    [gameLayer spawnActors];
    
    // init/prelaod audio and start background music
    [gameLayer initAudio];
    
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        // gcd
        backgroundQueue = dispatch_queue_create("de.staticline.gamelayer.bgqueue", NULL);  
        
        // settings
        self.isTouchEnabled = YES;
        self.activeTargets = [NSMutableArray arrayWithCapacity:1];
        
        // set scheduler
        [self schedule:@selector(nextFrame:)];
        
        // currently not used
        self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"atlas.pvr.ccz" capacity:4000];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas.plist"];
        
        self.gameModel = [STLGameModel sharedInstance];
    }
    return self;
}

- (void)spawnActors
{
    // add player
    _gameModel.player = [[STLPlayer alloc] init];
    _gameModel.player.node.zOrder = 5;
    _gameModel.player.node.position = [_world playerSpawnPoint];
    [self addChild:_gameModel.player.node];
    
    // add bear - the other good guy in game
    _gameModel.bear = [[STLBear alloc] init];
    CGSize size = [[CCDirector sharedDirector] winSize];
    // set him to the lower right corner
    _gameModel.bear.node.position =  ccp( size.width * 0.7 , size.height * 0.3 );
    _gameModel.bear.node.zOrder = 0;
    // walking around (atm, just animation)
    [_gameModel.bear startWalkAnimation];
    _gameModel.bear.node.position = [_world bearSpawnPoint];
    [self addChild:_gameModel.bear.node];
    
    // enemies
    for (NSValue *value in [_world enemySpawnPoints]) {
        STLEnemy *enemy = [[STLEnemy alloc] init];
        enemy.node.position = value.CGPointValue;
        enemy.node.zOrder = 1;
        [_gameModel.enemies addObject:enemy];
        [self addChild:enemy.node];
    }
    
    // center on player
    [self setViewpointCenter:_gameModel.player.node.position];
}

- (void)initAudio
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    [engine preloadBackgroundMusic:BACKGROUND_MUSIC_FILE];
    if (engine.willPlayBackgroundMusic) {
        engine.backgroundMusicVolume = 0.7;
        //[engine playBackgroundMusic:BACKGROUND_MUSIC_FILE];
    }
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
    [_gameModel update:dt];
    
    // container for all objects to be removed
    NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
    
    // hit test: player location vs. marker
    for (id<STLTargetProtocol> target in _activeTargets) {
        if (CGRectIntersectsRect(target.node.boundingBox, _gameModel.player.node.boundingBox)) {
            // target destruction
            [target removeFromGamewithActionType:kSTLTargetExplode];
            // mark as "to delete"
            [targetsToDelete addObject:target];
            
            dispatch_sync(backgroundQueue, ^{
                // player logic (score,achievements,...)
                [_gameModel.player killedTarget:target];
                // update hud
                [_hud.scoreLabel setString:[NSString stringWithFormat:@"%d",_gameModel.player.score]];
            });
        }
    }
    
    // quick 'n dirty hit test with the bear
    if (CGRectIntersectsRect(_gameModel.bear.node.boundingBox, _gameModel.player.node.boundingBox)) {
        [_gameModel.bear onPlayerCollision];
    } else if (!_gameModel.bear.isMoving) {
        // restart bear movement
        [_gameModel.bear startWalkAnimation];
    }

    // remove objects
    for (id<STLTargetProtocol> target in targetsToDelete) {
        [_activeTargets removeObject:target];
    }
    
    // center view on player
    [self setViewpointCenter:_gameModel.player.node.position];
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
            // collidable?
            NSString *collision = [properties valueForKey:@"collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                NSLog(@"no movement to this position");
                return;
            }
            
            // sign?
            NSString *sign = [properties valueForKey:@"isSign"];
            if (sign && [sign compare:@"True"] == NSOrderedSame) {
                float dist = ccpDistance(_gameModel.player.node.position, touchLocation);
                if (dist <= 70) {
                    // sign
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"a sign" 
                                                                    message:@"BEWARE OF THE SIGN!" 
                                                                   delegate:nil 
                                                          cancelButtonTitle:@"wtf?!?" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [_hud showConversation:-1];
                }
                return;
            }
        }
    }
    
    // check in between (naive solution)
    CGPoint movementVector = ccpNormalize(ccpSub(touchLocation,_gameModel.player.node.position));
    int STEPS = (int)ccpDistance(touchLocation, _gameModel.player.node.position);
    CGPoint toCheck = ccpAdd(_gameModel.player.node.position, movementVector);
    for (int step=1; step<STEPS; step++) {
        tileCoord = [_world tileCoordForPosition:toCheck];
        tileGid = [_world.meta tileGIDAt:tileCoord];
        if (tileGid) {
            NSDictionary *properties = [_world.tileMap propertiesForGID:tileGid];
            if (properties) {
                NSString *collision = [properties valueForKey:@"collidable"];
                if (collision && [collision compare:@"True"] == NSOrderedSame) {
                    NSLog(@"no DIRECT movement to this position");
                    // TODO: implement way-finding
                    return;
                }
            }
        }
        toCheck = ccpAdd(toCheck, movementVector);
    }

#pragma message "move? shoot?"
    DLog(@"shoot mode? %d", self.hud.inShootMode);
    if (self.hud.inShootMode) {
        [_gameModel.player shootToDirection:movementVector];
    } else {
        // move player to touched location
        [_gameModel.player movePlayerToDestination:touchLocation];
    }
    
    // set a marker
    //STLMarker *marker = [[STLMarker alloc] init];
    //marker.node.position = touchLocation;
    //[self addChild:marker.node];
    //[self.activeTargets addObject:marker];
}

# pragma mark - HUD delegate

- (BOOL)toggleGamePause
{
    if (isPaused) {
        // reactivate touch
        self.isTouchEnabled = YES;
        // resume game
        [[CCDirector sharedDirector] resume];
    } else {
        // pause touch interaction on this layer
        self.isTouchEnabled = NO;
        // pause the game
        [[CCDirector sharedDirector] pause];
    }
    isPaused = !isPaused;
    return isPaused;
}

- (BOOL)toogleBackgroundMusic
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    if (engine.isBackgroundMusicPlaying) {
        [engine stopBackgroundMusic];
    } else {
        [engine playBackgroundMusic:BACKGROUND_MUSIC_FILE];
    }
    return engine.isBackgroundMusicPlaying;
}

@end
