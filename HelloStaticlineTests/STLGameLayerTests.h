//
//  STLGameLayerTests.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"
#import "STLGameLayer.h"


@interface STLGameLayerTests : SenTestCase<CCDirectorDelegate> {
@private
    UIWindow *window_;
    UINavigationController *navController_;
    CCDirector *director_;
    
    STLGameLayer *_gameLayer;
}

@end
