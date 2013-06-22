//
//  STLEnemy.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLActorProtocol.h"

@interface STLEnemy : NSObject<STLTargetProtocol>

- (void) onPlayerCollision;

@end
