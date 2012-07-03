//
//  STLGKAchievementManager.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 01.07.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

// reset achievements in debug environment?
#define RESET_ACHIEVEMENTS 1

/*
 define some achievement key constants
 */
extern NSString * const kSTLAchievementKill1;
extern NSString * const kSTLAchievementKill20;

/*
 Mostly a 1:1 copy of Apple's example code
 */
@protocol STLGameCenterManagerProtocol <NSObject>
// store all achievement objects
@property (nonatomic,retain) NSMutableDictionary *achievementsDictionary;

// general actions
- (BOOL) isGameCenterAPIAvailable;
- (void) authenticateLocalPlayer;

// achievement handling
- (void) loadAchievements;
- (GKAchievement *) getAchievementForIdentifier: (NSString*) identifier;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;

// leaderboard
// ...
@end


/*
 singleton game center helper
 */
@interface STLGameCenterManager : NSObject<STLGameCenterManagerProtocol>
+ (STLGameCenterManager *)sharedInstance;
@end
