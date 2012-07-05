//
//  STLBear.h
//  HelloStaticline
//
//  The bear is kidnapped from Ray Wenderlich's demo. For more informations see:
//  http://www.raywenderlich.com/1271/how-to-use-animations-and-sprite-sheets-in-cocos2d
//
//  - no other pets have been harmed during the coding of this game -
//
//  Created by Carsten Witzke on 05.07.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "STLActorProtocol.h"

@interface STLBear : NSObject<STLActorProtocol> {
    BOOL _moving;
}

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

@end
