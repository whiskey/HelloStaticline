//
//  STLMarker.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 30.06.12.
//  Copyright 2012 staticline. All rights reserved.
//

#import "STLMarker.h"

@interface STLMarker()
//
@end

@implementation STLMarker
@synthesize node = _node;
@synthesize pointValue = _pointValue;

- (id)init
{
    self = [super init];
    if (self) {
        // marker has point values between 5 and 50 in steps of 5
        _pointValue = (arc4random() % 10 + 1) * 5;
    }
    return self;
}

@end
