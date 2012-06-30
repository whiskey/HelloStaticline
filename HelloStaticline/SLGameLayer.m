//
//  SLGameLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "SLGameLayer.h"

@interface SLGameLayer() {
    CCSprite *player;
}
- (void) nextFrame:(ccTime)dt;
@end

@implementation SLGameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    SLGameLayer *gameLayer = [SLGameLayer node];
    [scene addChild:gameLayer];
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {        
        player = [CCSprite spriteWithFile:@"player.png"];
        player.position = ccp( 100, 100 );
        [self addChild:player];
        
        [self schedule:@selector(nextFrame:)];
    }
    return self;
}

- (void)nextFrame:(ccTime)dt
{
    // very simple (and stupid) movement
    CGSize window = [[CCDirector sharedDirector] winSize];
    CGFloat newX = player.position.x;
    CGFloat newY = player.position.y;
    // x
    if (player.position.x < window.width) {
        newX += 100*dt;
    } else {
        newX = -50;
    }
    // y
    if (player.position.y < window.height) {
        newY += 100*dt;
    } else {
        newY = -20;
    }
    // set new position
    player.position = ccp( newX, newY );
}

@end
