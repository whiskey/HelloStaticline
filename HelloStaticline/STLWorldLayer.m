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
@synthesize meta = _meta;

- (id)init
{
    self = [super init];
    if (self) {
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        _background = [_tileMap layerNamed:@"Background"];
        
        // (invisible) meta layer
        _meta = [_tileMap layerNamed:@"Meta"];
        _meta.visible = NO;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            [_tileMap setScale:2.0f];
        } else {
            [_tileMap setScale:1.0f];
        }
        
        [self addChild:_tileMap z:-1];
    }
    return self;
}


#pragma mark - world layer helpers

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
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
