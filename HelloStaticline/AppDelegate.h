//
//  AppDelegate.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright staticline 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "STLGameNavigationController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	STLGameNavigationController *navController_;
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) STLGameNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
