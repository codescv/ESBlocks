//
//  UIActionSheet+ESBlocks.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIActionSheet+ESBlocks.h"
#import "NSObject+ESPropertyGeneration.h"

@interface ESBlocksActionSheetDelegate : NSObject <UIActionSheetDelegate>

@end

@implementation ESBlocksActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        if (actionSheet.cancelBlock) {
            actionSheet.cancelBlock();
        }
        return;
    }
    
    if (actionSheet.dismissBlock) {
        actionSheet.dismissBlock(actionSheet, buttonIndex);
    }
}

@end

@implementation UIActionSheet (ESBlocks)

static ESBlocksActionSheetDelegate *__delegate = NULL;

@dynamic dismissBlock;
@dynamic cancelBlock;

+ (void)load
{
    @autoreleasepool {
        __delegate = [[ESBlocksActionSheetDelegate alloc] init];
        [UIActionSheet defineProperty:@"dismissBlock" type:ES_PROP_COPY];
        [UIActionSheet defineProperty:@"cancelBlock" type:ES_PROP_COPY];
    }
}

- (void)show
{
    [self showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)titles 
           onCancel:(VoidBlock)cancelBlock 
          onDismiss:(ActionSheetDismissBlock)dismissBlock
{
    self = [self initWithTitle:title 
                      delegate:__delegate
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    if (self) {
        for(NSString *buttonTitle in titles)
            [self addButtonWithTitle:buttonTitle];
        int count = [titles count];
        
        if (destructiveButtonTitle != nil) {
            [self addButtonWithTitle:destructiveButtonTitle];
            count++;
            self.destructiveButtonIndex = count - 1;
        }
        
        if (cancelButtonTitle != nil) {
            [self addButtonWithTitle:cancelButtonTitle];
            count++;
            self.cancelButtonIndex = count - 1;
        }
        
        self.dismissBlock = dismissBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

+ (id)actionSheetWithTitle:(NSString *)title
         cancelButtonTitle:(NSString *)cancelButtonTitle
    destructiveButtonTitle:(NSString *)destructiveButtonTitle
         otherButtonTitles:(NSArray *)titles 
                  onCancel:(VoidBlock)cancelBlock 
                 onDismiss:(ActionSheetDismissBlock)dismissBlock
{
    return [[UIActionSheet alloc] initWithTitle:title
                              cancelButtonTitle:cancelButtonTitle 
                         destructiveButtonTitle:destructiveButtonTitle
                              otherButtonTitles:titles
                                       onCancel:cancelBlock
                                      onDismiss:dismissBlock];
}

+ (id)actionSheetWithTitles:(NSArray *)titles onDismiss:(ActionSheetDismissBlock)dismissBlock
{
    return [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Action", @"Select Action in actionsheet")
                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel in actionsheet")
                         destructiveButtonTitle:nil
                              otherButtonTitles:titles
                                       onCancel:^{}
                                      onDismiss:dismissBlock];
}

@end
