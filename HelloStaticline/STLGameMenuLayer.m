//
//  STLGameMenuLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 15.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLGameMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "STLAppDelegate.h"

@interface STLGameMenuLayer()
@property (strong, nonatomic) UINavigationController *navigationController;
+ (NSString *)stringForCurrentMusicStatus;
@end

@implementation STLGameMenuLayer
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.navigationController = [[CCDirector sharedDirector] navigationController];
        
        // a black background to hide the game layer completely
        CCLayerColor *solidBackground = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0.5f) 
                                                               width:winSize.width 
                                                              height:winSize.height];
        [self addChild:solidBackground z:-1];
        
        // the background sprite
        CCSprite *background = [CCSprite spriteWithFile:@"gamemenu.png"];    
        background.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:background];
        
        // a simple menu
        __block CCMenuItemFont *musicItem = [CCMenuItemFont itemWithString:[STLGameMenuLayer stringForCurrentMusicStatus] block:^(id sender) {
            [delegate toogleBackgroundMusic];
            [musicItem setString:[STLGameMenuLayer stringForCurrentMusicStatus]];
        }];
        
        // Achievements
        CCMenuItem *achievementItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"Achievements", @"Achievements") block:^(id sender) {
            // show achievements
            GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;

			[_navigationController presentViewController:achivementViewController animated:YES completion:nil];
			[achivementViewController release];
        }];
        
        // Leaderboard
        CCMenuItem *leaderboardItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"Leaderboard", @"Leaderboard") block:^(id sender) {
            GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
    
			[_navigationController presentViewController:leaderboardViewController animated:YES completion:nil];
			[leaderboardViewController release];
        }];
        
        // back to game
        CCMenuItem *backItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"back", @"back") block:^(id sender) {
            // resume game and pop scene
            [delegate toggleGamePause];
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: musicItem, achievementItem, leaderboardItem, backItem, nil];
        [menu alignItemsVerticallyWithPadding:15.0f];
        CGSize size = [[CCDirector sharedDirector] winSize];
        [menu setPosition:ccp( size.width/4, size.height/2)];
        [self addChild:menu];
    }
    return self;
}

+ (NSString *)stringForCurrentMusicStatus
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    NSString *musicString = engine.isBackgroundMusicPlaying ? 
        NSLocalizedString(@"Music off", @"Music off") : NSLocalizedString(@"Music on", @"Music on");
    return musicString;
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[_navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[_navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
