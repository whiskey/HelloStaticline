//
//  STLGameObjectsTests.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLGameObjectsTests.h"
#import "STLPlayer.h"
#import "STLMarker.h"

@implementation STLGameObjectsTests

- (void)testPlayerInitialGameScore
{
    STLPlayer *player = [[[STLPlayer alloc] init] autorelease];
    STAssertTrue(player.score == 0, @"initial player score should be 0");
}

@end
