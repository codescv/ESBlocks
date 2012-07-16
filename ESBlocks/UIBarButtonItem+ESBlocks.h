//
//  UIBarButtonItem+ESBlocks.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESBlocks.h"

@interface UIBarButtonItem (ESBlocks)

@property (nonatomic, copy) VoidBlock actionBlock;

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(VoidBlock)block;
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(VoidBlock)block;
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style block:(VoidBlock)block;
+ (id)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(VoidBlock)block;
+ (id)barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(VoidBlock)block;
+ (id)barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style block:(VoidBlock)block;

@end
