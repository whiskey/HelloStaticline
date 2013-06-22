//
//  STLAimMenuItem.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "STLAimMenuItem.h"

@implementation STLAimMenuItem

- (id)init
{
    self = [super initWithNormalImage:@"aim.png" selectedImage:@"aim.png" disabledImage:@"aim.png" block:nil];
    if (self) {
        //
    }
    return self;
}

- (void)selected
{
    [super selected];
    [self.delegate aimStateUpdate:YES];
}

- (void)unselected
{
    [super unselected];
    [self.delegate aimStateUpdate:NO];
}

@end
