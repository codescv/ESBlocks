//
//  UIViewController+ESAdditions.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIViewController+ESAdditions.h"

@implementation UIViewController (ESAdditions)

- (void)dismissAsModalViewControllerAnimated:(BOOL)animated
{
    if (self.navigationController) {
        [self.navigationController dismissAsModalViewControllerAnimated:animated];
    } else if ([self respondsToSelector:@selector(presentingViewController)]) {
        [self.presentingViewController dismissModalViewControllerAnimated:animated];
    } else {
        [self.parentViewController dismissModalViewControllerAnimated:animated];
    }
}

@end
