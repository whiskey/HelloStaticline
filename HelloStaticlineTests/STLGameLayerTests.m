//
//  STLGameLayerTests.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLGameLayerTests.h"

@implementation STLGameLayerTests


- (void)setUp
{
    [super setUp];
    // use default macro to prepare director
    CC_DIRECTOR_INIT();
    [director_ runWithScene:[STLGameLayer scene]];
    _gameLayer = [director_.runningScene.children objectAtIndex:0];
}

- (void)tearDown
{
    _gameLayer = nil;
    window_ = nil;
    navController_ = nil;
    director_ = nil;
    [super tearDown];
}

- (void)testSceneExistence
{
    STAssertNotNil([STLGameLayer scene], @"game layer's scene can't be nil");
}

- (void)testGameLayerExistence
{
    STAssertNotNil(director_, @"no director");
    STAssertNotNil(_gameLayer, @"game layer can't be nil");
}

- (void)testPlayerExistence
{
    STAssertNotNil(_gameLayer.player, @"game layer doesn't contain player object");
}

//- (void)testSpriteDestruction
//{
//    
//}


@end
