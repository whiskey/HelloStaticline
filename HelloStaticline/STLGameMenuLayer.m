//
//  STLGameMenuLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 15.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLGameMenuLayer.h"
#import "SimpleAudioEngine.h"

@interface STLGameMenuLayer()
+ (NSString *)stringForMusicStatus;
@end

@implementation STLGameMenuLayer
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
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
        __block CCMenuItemFont *musicItem = [CCMenuItemFont itemWithString:[STLGameMenuLayer stringForMusicStatus] block:^(id sender) {
            [delegate toogleBackgroundMusic];
            [musicItem setString:[STLGameMenuLayer stringForMusicStatus]];
        }];
        
        // back to game
        CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
            // resume game and pop scene
            [delegate toggleGamePause];
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: musicItem, backItem, nil];
        [menu alignItemsVerticallyWithPadding:5.0f];
        CGSize size = [[CCDirector sharedDirector] winSize];
        [menu setPosition:ccp( size.width/4, size.height/2)];
        [self addChild:menu];
    }
    return self;
}

+ (NSString *)stringForMusicStatus
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    NSString *musicString = engine.isBackgroundMusicPlaying ? 
        NSLocalizedString(@"Music off", @"Music off") : NSLocalizedString(@"Music on", @"Music on");
    return musicString;
}

@end
