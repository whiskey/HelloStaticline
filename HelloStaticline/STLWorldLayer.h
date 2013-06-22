//
//  STLLevelLayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 08.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface STLWorldLayer : CCLayer

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *meta;

// using tile coordinates
- (CGPoint)tileCoordForPosition:(CGPoint)position;

// 2 helpers and general spawnpoint getter
- (CGPoint)playerSpawnPoint;
- (CGPoint)bearSpawnPoint;
- (NSArray *)enemySpawnPoints;

- (CGPoint)spawnPointForObject:(NSString *)type;
- (NSArray *)spawnPointForObjects:(NSString *)type;
@end
