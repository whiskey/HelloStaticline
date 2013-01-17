//
//  main.m
//  HelloStaticline
//
//  Created by Carsten Witzke on 27.06.12.
//  Copyright staticline 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLAppDelegate.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([STLAppDelegate class]));
    [pool release];
    return retVal;
}
