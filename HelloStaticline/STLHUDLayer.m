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
        [self.scoreLabel setPosition:ccp(winSize.width-10,winSize.height-90)];
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
    self.scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"blood_font_80.fnt"];
    _scoreLabel.scale = CC_CONTENT_SCALE_FACTOR();
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
