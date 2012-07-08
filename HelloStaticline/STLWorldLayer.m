//
//  STLLevelLayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 08.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLWorldLayer.h"


@implementation STLWorldLayer
@synthesize tileMap = _tileMap;
@synthesize background = _background;

- (id)init
{
    self = [super init];
    if (self) {
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        _background = [_tileMap layerNamed:@"Background"];
        [self addChild:_tileMap z:-1];
    }
    return self;
}

- (void)dealloc
{
    self.tileMap = nil;
    self.background = nil;
    [super dealloc];
}

- (CGPoint)playerSpawnPoint
{
    return [self spawnPointForObject:@"player"];
}

- (CGPoint)bearSpawnPoint
{
    return [self spawnPointForObject:@"bear"];
}

/*
 quick 'n dirty! string constants will follow later
 */
- (CGPoint)spawnPointForObject:(NSString *)type
{
    NSString *spName = [NSString stringWithFormat:@"spawnpoint_%@",type];
    NSLog(@"type: %@",spName);
    // get the spawnpoint property from the tile map
    CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    NSMutableDictionary *spawnPoint = [objects objectNamed:spName];
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    return CGPointMake(x, y);
}

@end
