//
//  SLPlayer.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STLActorProtocol.h"

@interface STLPlayer : NSObject<STLActorProtocol>
@property (nonatomic,readonly) NSUInteger score;
@property (nonatomic,readonly) NSUInteger level;
@property (nonatomic,readonly) NSUInteger lifetimeCatchedMarkers;

// methods...
// - reset
// - update some stats

@end
