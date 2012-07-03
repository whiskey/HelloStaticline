//
//  STLHUDLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 03.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLHUDLayer.h"

@interface STLHUDLayer()

@end

@implementation STLHUDLayer
@synthesize scoreLabel = _scoreLabel;

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // create and place score label
        [self.scoreLabel setPosition:ccp(winSize.width-50,winSize.height-60)];
        // TODO: label will clip if score > 4 digits
        [self addChild:_scoreLabel];
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
    return _scoreLabel;
}


@end
