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

static STLGameCenterManager *sharedInstance;

@implementation STLGameCenterManager
@synthesize achievementsDictionary = _achievementsDictionary;

#pragma mark - singleton

+ (STLGameCenterManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.achievementsDictionary = [NSMutableDictionary dictionary];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copy
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    // no action
    // oneway: http://stackoverflow.com/questions/7379470/singleton-release-method-produces-warning
}

- (id)autorelease
{
    return self;
}


#pragma mark - game center
/*
 Check whether or not the game center api is available
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
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated) {
#if DEBUG && RESET_ACHIEVEMENTS
            // reset all achievements - DEBUG/DEVELOPMENT ONLY!
            NSLog(@"### RESET ACHIEVEMENTS ###");
            [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
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
            NSLog(@"%@",error);
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
                NSLog(@"%@",error);
            }
#endif
        }
        NSLog(@"%s got %d achievements",__PRETTY_FUNCTION__,achievements.count);
        if (achievements != nil) {
            // process the array of achievements.
            for (GKAchievement *achievement in achievements) {
                NSLog(@"%@ - %f%% complete",achievement.identifier,achievement.percentComplete);
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
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [_achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return [[achievement retain] autorelease];
}

/*
 reports an avievement progress to the game center network
 */
- (void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        // show notification
        if (achievement.completed) {
            achievement.showsCompletionBanner = YES;
        }
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
#if DEBUG
             if (error != nil)
             {
                 NSLog(@"%@",error);
                 // TODO: handle sync
             }
#endif
         }];
    }
}

@end
