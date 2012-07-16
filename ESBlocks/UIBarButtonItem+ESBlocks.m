//
//  UIBarButtonItem+ESBlocks.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIBarButtonItem+ESBlocks.h"
#import "NSObject+ESPropertyGeneration.m"

@interface ESBarButtonItemDelegate : NSObject <UIAlertViewDelegate>

@end

@implementation ESBarButtonItemDelegate 

- (void)barItemTouched:(UIBarButtonItem *)item
{
    if (item.actionBlock) {
        item.actionBlock();
    }
}

@end

@implementation UIBarButtonItem (ESBlocks)

@dynamic actionBlock;

static ESBarButtonItemDelegate *__delegate = nil;

+ (void)load
{
    __delegate = [[ESBarButtonItemDelegate alloc] init];
    [UIBarButtonItem defineProperty:@"actionBlock" type:ES_PROP_COPY];
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(VoidBlock)block
{
    id obj = [self initWithBarButtonSystemItem:systemItem target:__delegate action:@selector(barItemTouched:)];
    self.actionBlock = block;
    return obj;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(VoidBlock)block
{
    id obj = [self initWithTitle:title style:style target:__delegate action:@selector(barItemTouched:)];
    self.actionBlock = block;
    return obj;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style block:(VoidBlock)block;
{
    id obj = [self initWithImage:image style:style target:__delegate action:@selector(barItemTouched:)];
    self.actionBlock = block;
    return obj;
}


+ (id)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(VoidBlock)block
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem block:block];
}

+ (id)barButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(VoidBlock)block 
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:style block:block];
}

+ (id)barButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style block:(VoidBlock)block
{
    return [[UIBarButtonItem alloc] initWithImage:image style:style block:block];
}

@end
