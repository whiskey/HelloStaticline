//
//  SLPlayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLPlayer.h"
#import "STLGameCenterManager.h"
#import "SimpleAudioEngine.h"

#define PLAYER_MOVEMENT_SOUND @"player_walk.caf"

/*
 Player extension. Make readonly properties accessible for private use.
 */
@interface STLPlayer() {
    ALuint movementSoundID;
}
@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,assign) NSUInteger level;
@property (nonatomic,assign) NSUInteger lifetimeCatchedMarkers;
@property (nonatomic,assign) STLGameCenterManager *gcm;
- (void)checkAchievementProgress;
@end


@implementation STLPlayer
@synthesize node = _node;
@synthesize sprite = _sprite;
@synthesize score = _score;
@synthesize level = _level;
@synthesize lifetimeCatchedMarkers = _lifetimeCatchedMarkers;
@synthesize gcm = _gcm;

- (id) init
{
    self = [super init];
    if (self) {
        // init score
        self.score = 0;
        
        // the next two values will be stored and read persistantly,
        // currently just using dummy values
        self.level = 0;
        self.lifetimeCatchedMarkers = 0;
        
        // get the achievement manager
        _gcm = [STLGameCenterManager sharedInstance];
        
        // preload sounds
        [[SimpleAudioEngine sharedEngine] preloadEffect:PLAYER_MOVEMENT_SOUND];
    }
    return self;
}

- (CCNode *)node
{
    if (_node) {
        return _node;
    }
    // init with spritesheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_sprite_default.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"player_sprite_default.png"];
    _node = [CCNode node];
    [_node addChild:spriteSheet];
    // standing still
    _sprite = [CCSprite spriteWithSpriteFrameName:@"player_d_1.png"];
    // scaling - better: use hd sprites
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        [_sprite setScale:1.0f];
    } else {
        [_sprite setScale:0.5f];
    }
    [spriteSheet addChild:_sprite];
    _node.contentSize = _sprite.contentSize;
    return _node;
}

#pragma mark - gameplay

- (void) killedTarget:(id<STLTargetProtocol>) target
{
    // very simple stats-update
    self.score += target.pointValue;
    self.lifetimeCatchedMarkers++;
    // check for new achievements
    [self checkAchievementProgress];
}

#pragma mark - ui actions

- (void)movePlayerToDestination:(CGPoint)destination
{
    // existing movement action running? stop.
    [_node stopAllActions];
    [_sprite stopAllActions];
    
    // some static values
    // 8 movement directions, 2 arcs left and right of each
    static float step = M_PI*2 / PLAYER_NUMBER_MOVEMENT_DIRECTIONS;
    static float arc = M_PI / PLAYER_NUMBER_MOVEMENT_DIRECTIONS;
    // init array - condition looks weird to me but works for now
    static float bounds[PLAYER_NUMBER_MOVEMENT_DIRECTIONS][2];
    if (bounds[0][0] == bounds[0][1]) {
        // compute upper and lower bounds for each movement direction
        for (int i=0; i<PLAYER_NUMBER_MOVEMENT_DIRECTIONS; i++) {
            // left border
            float left = step * i - arc;
            bounds[i][0] = (left < 0) ? M_PI*2+left : left;
            // right border
            float right = step * i + arc;
            bounds[i][1] = (right > M_PI*2) ? right-(M_PI*2) : right;
        }
    }
    
    // current movement direction
    CGPoint destWorld = [[CCDirector sharedDirector] convertToGL:destination];
    CGPoint nodeWorld = [[CCDirector sharedDirector] convertToGL:_node.position];
    float moveAngle = ccpToAngle(ccpSub(destWorld,nodeWorld));
    if (moveAngle < 0) {
        moveAngle = M_PI*2 + moveAngle;
    } else if (moveAngle > M_PI*2) {
        moveAngle = moveAngle - M_PI*2;
    }
    
    // compare current movement angle to the 8 stored directions
    NSString *movementDir = nil;
    for (int i=1; i<PLAYER_NUMBER_MOVEMENT_DIRECTIONS; i++) {
        // between bounds?
        if (moveAngle>bounds[i-1][1] && moveAngle<=bounds[i][1]) {
            switch (i) {
                case 1:
                    //NSLog(@"down right");
                    movementDir = @"dr";
                    break;
                case 2:
                    //NSLog(@"down");
                    movementDir = @"d";
                    break;
                case 3:
                    //NSLog(@"down left");
                    movementDir = @"dl";
                    break;    
                case 4:
                    //NSLog(@"left");
                    movementDir = @"l";
                    break;
                case 5:
                    //NSLog(@"up left");
                    movementDir = @"ul";
                    break;
                case 6:
                    //NSLog(@"up");
                    movementDir = @"u";
                    break;
                case 7:
                    //NSLog(@"up right");
                    movementDir = @"ur";
                    break;
                default:
                    NSLog(@"some weird stuff which should never happen");
                    break;
            }
            break;
        } else if (i == 7) {
            //NSLog(@"right");
            movementDir = @"r";
            break;
        }
    }
    // create sprite animation acording to movement direction
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int frame=1; frame<=3; frame++) {
        NSString *frameSprite = [NSString stringWithFormat:@"player_%@_%d.png",movementDir,frame];
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameSprite]];
    }
    // animation
    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.2f];    
    CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
    walkAction.tag = kSTLPlayerWalkAction;
    [_sprite runAction:walkAction];
    // sound
    movementSoundID = [[SimpleAudioEngine sharedEngine] playEffect:PLAYER_MOVEMENT_SOUND];
    
    // create movement with ease in/out
    id movement = [CCMoveTo actionWithDuration:2.0f position:destination];
    [movement setTag:kSTLPlayerMovement];
    id ease = [CCEaseInOut actionWithAction:movement rate:2.0f];
    id stopAnimation = [CCCallBlock actionWithBlock:^{
        [_sprite stopAllActions];
        [_sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: @"player_d_1.png"]];
        // stop sound
        // currently not needed, but might become relevant with a sound-loop for each step
//        [[SimpleAudioEngine sharedEngine] stopEffect:movementSound];
//        movementSound = 0;
        // do some waiting animation...
    }];
    id sequence = [CCSequence actions:ease, stopAnimation, nil];
    [_node runAction:sequence];
}

#pragma mark - achievement handling

- (void) checkAchievementProgress
{
    // TODO: handle intermediate progress
    // lifetime kills
    if (_lifetimeCatchedMarkers == 1) {
        [_gcm reportAchievementIdentifier:kSTLAchievementKill1 
                         percentComplete:100.0f];
    } else if (_lifetimeCatchedMarkers == 20) {
        [_gcm reportAchievementIdentifier:kSTLAchievementKill20 
                         percentComplete:100.0f];
    }
}

@end
