//
//  SLPlayer.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLPlayer.h"

/*
 Player extension. Make readonly properties accessible for private use.
 */
@interface STLPlayer()
@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,assign) NSUInteger level;
@property (nonatomic,assign) NSUInteger lifetimeCatchedMarkers;
@end


@implementation STLPlayer
@synthesize node = _node;
@synthesize score = _score;
@synthesize level = _level;
@synthesize lifetimeCatchedMarkers = _lifetimeCatchedMarkers;


- (id)init
{
    self = [super init];
    if (self) {
        // init score
        self.score = 0;
        
        // the next two values will be stored and read persistantly,
        // currently just using dummy values
        self.level = 0;
        self.lifetimeCatchedMarkers = 0;
    }
    return self;
}

@end
