//
//  STLGKAchievementManager.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 01.07.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLGameCenterManager.h"

NSString *const kSTLAchievementKill1    = @"1_kill1";
NSString *const kSTLAchievementKill20   = @"2_kill20";
NSString *const kSTLAchievementFindBear = @"find_bear";

static STLGameCenterManager *sharedInstance;

@implementation STLGameCenterManager
@synthesize achievementsDictionary = _achievementsDictionary;

#pragma mark - singleton

+ (STLGameCenterManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static STLGameCenterManager *_sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[STLGameCenterManager alloc] init];
        _sharedObject.achievementsDictionary = [NSMutableDictionary dictionary];
    });
    return _sharedObject;
}

#pragma mark - game center
/**
 Check whether or not the game center api is available
 @returns YES if GKLocalPlayer class is available and current OS version is supported
 */
- (BOOL) isGameCenterAPIAvailable
{
    // Check for presence of GKLocalPlayer class.
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
    
    // The device must be running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (localPlayerClassAvailable && osVersionSupported); 
}

/*
 authenticates the local player to the game center network
 */
-(void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
        if (localPlayer.isAuthenticated) {
#if DEBUG && RESET_ACHIEVEMENTS
            // reset all achievements - DEBUG/DEVELOPMENT ONLY!
            NSLog(@"### RESET ACHIEVEMENTS ###");
            [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
                if (error) {
                    NSLog(@"resetAchievementsWithCompletionHandler error: %@",error);
                }
                [self loadAchievements];
            }];
#else
            [self loadAchievements];
#endif
        }
#if DEBUG
        // display errors, if present
        if (error) {
            NSLog(@"authenticateWithCompletionHandler error: %@",error);
        }
#endif
    }];
}

/*
 loads all active achievements
 */
- (void) loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
#if DEBUG
            // display errors, if present
            if (error) {
                NSLog(@"loadAchievementsWithCompletionHandler error: %@",error);
            }
#endif
        }
        if (achievements != nil) {
            // process the array of achievements.
            for (GKAchievement *achievement in achievements) {
                //NSLog(@"%@ - %f%% complete",achievement.identifier,achievement.percentComplete);
                [_achievementsDictionary setObject:achievement forKey:achievement.identifier];
            }
        }
    }];
}

/*
 gets or creates an achievement with identifier
 */
- (GKAchievement*) getAchievementForIdentifier:(NSString*)identifier
{
    GKAchievement *achievement = [_achievementsDictionary objectForKey:identifier];
    if (achievement == nil)
    {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [_achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return achievement;
}

/*
 reports an avievement progress to the game center network
 */
- (void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
    // get achievement for current player account
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    // don't handle already finished achievements
    if (achievement && !achievement.completed)
    {
        achievement.percentComplete = percent;
        // show notification
        if (achievement.completed) {
            achievement.showsCompletionBanner = YES;
        }
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
#if DEBUG
             if (error != nil) {
                 NSLog(@"reportAchievementWithCompletionHandler error: %@",error);
                 // TODO: handle sync
             }
#endif
         }];
    }
}

@end
