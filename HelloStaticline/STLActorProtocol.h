//
//  STLActorProtocol.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol STLActorProtocol <NSObject>
@property (nonatomic,assign) CCNode* node;
@end


@protocol STLTargetProtocol <STLActorProtocol>
@property (nonatomic,assign) NSUInteger pointValue;
@end