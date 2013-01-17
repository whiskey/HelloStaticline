//
//  HelloWorldLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright staticline 2012. All rights reserved.
//


// Import the interfaces
#import "STLMainMenuLayer.h"
#import "STLAppDelegate.h"
#import "STLGameLayer.h"


@implementation STLMainMenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	STLMainMenuLayer *layer = [STLMainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
		// create and initialize a Label
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Hello Staticline" fntFile:@"nanum_large.fnt"];
        label.scale = [UIScreen mainScreen].scale/2;
		// position the label on the center of the screen
#warning switched width and height because CCDirector is still in portrait mode
        label.position = ccp(size.height/2,size.width/2 + label.boundingBox.size.height);
        // add the label as a child to this Layer
		[self addChild: label];

		//
		// main menu items
		//
		[CCMenuItemFont setFontSize:30];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			STLAppDelegate *app = (STLAppDelegate*) [[UIApplication sharedApplication] delegate];
			[[app navController] presentViewController:achivementViewController animated:YES completion:nil];
			[achivementViewController release];
		}];
        
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			STLAppDelegate *app = (STLAppDelegate*) [[UIApplication sharedApplication] delegate];
			[[app navController] presentViewController:leaderboardViewController animated:YES completion:nil];
			[leaderboardViewController release];
		}];
        
        // most important: game start
        CCMenuItem *gameStart = [CCMenuItemFont itemWithString:@"start game" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:
                    [CCTransitionFade transitionWithDuration:0.8f scene:[STLGameLayer scene]]];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:gameStart, itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
#warning switched width and height because CCDirector is still in portrait mode
		[menu setPosition:ccp( size.height/2, size.width/2)];
		
		// Add the menu to the layer
		[self addChild:menu];
	}
	return self;
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	STLAppDelegate *app = (STLAppDelegate*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	STLAppDelegate *app = (STLAppDelegate*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}
@end
