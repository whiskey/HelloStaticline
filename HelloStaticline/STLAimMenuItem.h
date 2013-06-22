//
//  STLAimMenuItem.h
//  HelloStaticline
//
//  Created by Carsten Witzke on 22.06.13.
//  Copyright (c) 2013 staticline. All rights reserved.
//

#import "CCMenuItem.h"

@protocol STLAimMenuItem <NSObject>

- (void)aimStateUpdate:(BOOL)aimActive;

@end

@interface STLAimMenuItem : CCMenuItemImage
@property (weak, nonatomic) id<STLAimMenuItem> delegate;

+ (STLAimMenuItem *) item;

@end
