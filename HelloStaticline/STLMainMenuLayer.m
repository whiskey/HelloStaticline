//
//  HelloWorldLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright staticline 2012. All rights reserved.
//


// Import the interfaces
#import "STLMainMenuLayer.h"
#import "AppDelegate.h"
#import "STLGameLayer.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
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
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello Staticline" fontName:@"Marker Felt" fontSize:60];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
//        int width=[[UIScreen mainScreen] bounds].size.width;
//        int height=[[UIScreen mainScreen] bounds].size.height;
//        CGPoint center=ccp(width/2,height/2);
        label.position = ccp( size.width /2, size.height/2 );
        
        NSLog(@"label: %@",NSStringFromCGRect(label.boundingBox));
		
		// add the label as a child to this Layer
		[self addChild: label];
				
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points on retina displays.
		[CCMenuItemFont setFontSize:22];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			[achivementViewController release];
		}];
        
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			[leaderboardViewController release];
		}
									   ];
        CCMenuItem *gameStart = [CCMenuItemFont itemWithString:@"start game" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:
                    [CCTransitionFlipAngular transitionWithDuration:0.8f scene:[STLGameLayer scene]]];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:gameStart, itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20]; //[UIScreen mainScreen].scale
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)]; // * [UIScreen mainScreen].scale
		
		// Add the menu to the layer
		[self addChild:menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
