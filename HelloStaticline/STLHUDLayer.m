//
//  STLHUDLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 03.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLHUDLayer.h"
#import "STLGameMenuLayer.h"


@interface STLHUDLayer()
@property (nonatomic,retain) CCLayer *gameMenu;
- (void)showGameMenu;
@end


@implementation STLHUDLayer
@synthesize delegate;
@synthesize scoreLabel = _scoreLabel;
@synthesize gameMenu = _gameMenu;

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // create and place score label
        [self.scoreLabel setPosition:ccp(winSize.width-10,winSize.height-55)];
        [self addChild:_scoreLabel];
        
        // pause / game menu
        CCMenuItemImage *pauseBtn = [CCMenuItemImage itemWithNormalImage:@"pause.png" 
                                                           selectedImage:@"pause.png" 
                                                                   block:^(id sender) 
        {
            if ([delegate toggleGamePause]) {
                [self showGameMenu];
            }
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:pauseBtn, nil];
        [menu setPosition:ccp(20, winSize.height - 24)];
        [self addChild:menu];
    }
    return self;
}

- (CCLabelAtlas *)scoreLabel
{
    if (_scoreLabel) {
        return _scoreLabel;
    }
    // TODO: own font, ...
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        self.scoreLabel = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                                    charMapFile:@"fps_images-hd.png" 
                                                      itemWidth:12
                                                     itemHeight:56 
                                                   startCharMap:'.'] autorelease];
    } else {
        // non-Retina display
        self.scoreLabel = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                                    charMapFile:@"fps_images.png" 
                                                      itemWidth:12
                                                     itemHeight:56 
                                                   startCharMap:'.'] autorelease];
    }
    _scoreLabel.anchorPoint = ccp(1,0);
    return _scoreLabel;
}

- (void)showGameMenu
{
    CCScene *scene = [CCScene node];
    STLGameMenuLayer *gml = [STLGameMenuLayer node];
    // set the (same) delegate as this HUD
    gml.delegate = delegate;
    [scene addChild:gml];
    [[CCDirector sharedDirector] pushScene:scene];
}

- (void)showConversation:(NSInteger)cID
{
    // TODO
//    STLConversationLayer *conv = [STLConversationLayer node];
//    [self addChild:conv];
}

@end
