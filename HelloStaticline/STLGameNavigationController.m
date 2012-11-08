//
//  STLGameNavigationController.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 28.10.12.
//  Copyright (c) 2012 staticline. All rights reserved.
//

#import "STLGameNavigationController.h"

@interface STLGameNavigationController ()

@end

@implementation STLGameNavigationController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
