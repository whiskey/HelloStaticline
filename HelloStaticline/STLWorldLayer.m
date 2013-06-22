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
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"street.tmx"];
        _background = [_tileMap layerNamed:@"Background"];
        
        // (invisible) meta layer
        _meta = [_tileMap layerNamed:@"Meta"];
        _meta.visible = NO;
        
        _tileMap.scale = CC_CONTENT_SCALE_FACTOR();
        
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

- (NSArray *)enemySpawnPoints
{
    return [self spawnPointForObjects:@"enemy"];
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
    if (!spawnPoint) {
        return CGPointZero;
    }
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    return CGPointMake(x, y);
}

- (NSArray *)spawnPointForObjects:(NSString *)type
{
    NSString *spName = [NSString stringWithFormat:@"spawnpoint_%@",type];
    // get the spawnpoint property from the tile map
    CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:objects.objects.count];
    for (NSMutableDictionary *spawnPoint  in objects.objects) {
        if (![[spawnPoint objectForKey:@"name"] isEqualToString:spName]) {
            continue;
        }
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        [points addObject:[NSValue valueWithCGPoint:ccp(x,y)]];
    }
    
    return points;
}

@end
