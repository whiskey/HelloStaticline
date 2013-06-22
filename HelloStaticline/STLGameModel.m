//
//  STLGameModel.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLGameModel.h"

@implementation STLGameModel

+ (STLGameModel *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static STLGameModel *_sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[STLGameModel alloc] init];
        _sharedObject.enemies = [NSMutableArray arrayWithCapacity:20];
        _sharedObject.projectiles = [NSMutableArray arrayWithCapacity:200];
    });
    return _sharedObject;
}

@end
