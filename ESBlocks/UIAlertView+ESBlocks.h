//
//  UIAlertView+ESBlocks.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESBlocks.h"

@interface UIAlertView (ESBlocks)

@property (nonatomic, copy) VoidBlock dismissBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;

- (id)initWithTitle:(NSString*) title                    
            message:(NSString*) message 
  cancelButtonTitle:(NSString*) cancelButtonTitle
  otherButtonTitles:(NSArray*) otherButtons
          onDismiss:(AlertDismissBlock) dismissed                   
           onCancel:(VoidBlock) cancelled;

+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message 
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(AlertDismissBlock) dismissed                   
                           onCancel:(VoidBlock) cancelled;

// an alertview with two options.
+ (UIAlertView *) doubleOptionAlertWithMessage:(NSString *)message
                           negativeButtonTitle:(NSString *)negativeTitle
                           positiveButtonTitle:(NSString *)positiveTitle
                                    onPositive:(VoidBlock)positiveDismiss
                                    onNegative:(VoidBlock)negativeDismiss;

// an alertview with two options: "yes" and "no".
+ (UIAlertView *) yesNoAlertWithMessage:(NSString *)message
                                  onYes:(VoidBlock)yesDismiss
                                   onNo:(VoidBlock)noDismiss;

@end
