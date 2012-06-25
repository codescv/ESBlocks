//
//  UIActionSheet+ESBlocks.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESBlocks.h"

@interface UIActionSheet (ESBlocks)

@property (nonatomic, copy) ActionSheetDismissBlock dismissBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;

- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)titles 
           onCancel:(VoidBlock)cancelBlock 
          onDismiss:(ActionSheetDismissBlock)dismissBlock;

+ (id)actionSheetWithTitle:(NSString *)title
         cancelButtonTitle:(NSString *)cancelButtonTitle
    destructiveButtonTitle:(NSString *)destructiveButtonTitle
         otherButtonTitles:(NSArray *)titles 
                  onCancel:(VoidBlock)cancelBlock 
                 onDismiss:(ActionSheetDismissBlock)dismissBlock;

// An actionsheet with default "Select Action" Title and a "Cancel" button, 
// and does nothing when user selects "Cancel"
+ (id)actionSheetWithTitles:(NSArray *)titles
                  onDismiss:(ActionSheetDismissBlock)dismissBlock;

- (void)show;

@end
