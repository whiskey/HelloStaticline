//
//  STLGameModel.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLPlayer.h"
#import "STLEnemy.h"
#import "STLBear.h"

@interface STLGameModel : NSObject

@property (strong, nonatomic) STLPlayer *player;
@property (strong, nonatomic) STLBear *bear;

@property (strong, nonatomic) NSMutableArray *enemies;
@property (strong, nonatomic) NSMutableArray *projectiles;

+ (STLGameModel *)sharedInstance;

- (void)update:(ccTime)delta;

@end
