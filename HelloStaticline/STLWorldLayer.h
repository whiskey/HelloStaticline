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

// 2 helper and one general spawnpoint getter
- (CGPoint)playerSpawnPoint;
- (CGPoint)bearSpawnPoint;
- (CGPoint)spawnPointForObject:(NSString *)type;
@end
