//
//  STLGameMenuLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 15.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLGameMenuLayer.h"


@implementation STLGameMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    
    CCLayer *gameMenuLayer = [CCLayer node];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // a black background to hide the game layer completely
    CCLayerColor *solidBackground = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0.5f) 
                                                           width:winSize.width 
                                                          height:winSize.height];
    [gameMenuLayer addChild:solidBackground z:-1];
    
    // the background sprite
    CCSprite *background = [CCSprite spriteWithFile:@"gamemenu.png"];    
    background.position = CGPointMake(winSize.width/2, winSize.height/2);
    [gameMenuLayer addChild:background];
    
    // a simple menu
    CCMenuItem *musicItem = [CCMenuItemFont itemWithString:@"Music on/off" block:^(id sender) {
        NSLog(@"toggle music");
    }];
    
    CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
        [[CCDirector sharedDirector] popScene];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems: musicItem, backItem, nil];
    [menu alignItemsVerticallyWithPadding:5.0f];
    //[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
    [gameMenuLayer addChild:menu];
    
    // finish and add
    [scene addChild:gameMenuLayer];
    
	return scene;
}



@end
