//
//  SLPlayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLPlayer.h"
#import "STLGKGameCenterManager.h"



/*
 Player extension. Make readonly properties accessible for private use.
 */
@interface STLPlayer()
@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,assign) NSUInteger level;
@property (nonatomic,assign) NSUInteger lifetimeCatchedMarkers;
@property (nonatomic,assign) STLGKGameCenterManager *gcm;
- (void)checkAchievementProgress;
@end


@implementation STLPlayer
@synthesize node = _node;
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
        _gcm = [STLGKGameCenterManager sharedInstance];
    }
    return self;
}

- (void) killedTarget:(id<STLTargetProtocol>) target
{
    // very simple stats-update
    self.score += target.pointValue;
    self.lifetimeCatchedMarkers++;
#if DEBUG
    NSLog(@"score: %d  catches total: %d",_score,_lifetimeCatchedMarkers);
#endif
    // check for new achievements
    [self checkAchievementProgress];
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
