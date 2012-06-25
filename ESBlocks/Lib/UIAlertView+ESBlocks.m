//
//  UIAlertView+ESBlocks.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIAlertView+ESBlocks.h"

#import "NSObject+ESPropertyGeneration.h"

@interface ESBlocksAlertViewDelegate : NSObject <UIAlertViewDelegate>

@end

@implementation ESBlocksAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (alertView.cancelBlock) {
            alertView.cancelBlock();
        }
        return;
    }
    
    if (alertView.dismissBlock) {
        alertView.dismissBlock(alertView, buttonIndex);
    }
}

@end

@implementation UIAlertView (ESBlocks)

static ESBlocksAlertViewDelegate *_es_block_delegate = NULL;

@dynamic dismissBlock;
@dynamic cancelBlock;

+ (void)load
{
    @autoreleasepool {
        _es_block_delegate = [[ESBlocksAlertViewDelegate alloc] init];
        [UIAlertView defineProperty:@"dismissBlock" type:ES_PROP_COPY];
        [UIAlertView defineProperty:@"cancelBlock" type:ES_PROP_COPY];
    }
}


- (id)initWithTitle:(NSString*)title                    
            message:(NSString*)message 
  cancelButtonTitle:(NSString*)cancelButtonTitle
  otherButtonTitles:(NSArray*)otherButtons
          onDismiss:(AlertDismissBlock)dismissed                   
           onCancel:(VoidBlock)cancelled
{
    self = [self initWithTitle:title
                       message:message
                      delegate:_es_block_delegate
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:nil];
    if (self) {
        for(NSString *buttonTitle in otherButtons)
            [self addButtonWithTitle:buttonTitle];
        
        self.dismissBlock = dismissed;
        self.cancelBlock = cancelled;
    }
    return self;
}

+ (UIAlertView *)alertViewWithTitle:(NSString*)title                    
                            message:(NSString*)message 
                  cancelButtonTitle:(NSString*)cancelButtonTitle
                  otherButtonTitles:(NSArray*)otherButtons
                          onDismiss:(AlertDismissBlock)dismissed                   
                           onCancel:(VoidBlock)cancelled
{
    return [[UIAlertView alloc] initWithTitle:title
                                      message:message
                            cancelButtonTitle:cancelButtonTitle 
                            otherButtonTitles:otherButtons
                                    onDismiss:dismissed 
                                     onCancel:cancelled];
}

+ (UIAlertView *)doubleOptionAlertWithMessage:(NSString *)message
                          negativeButtonTitle:(NSString *)negativeTitle
                          positiveButtonTitle:(NSString *)positiveTitle
                                   onPositive:(VoidBlock)positiveDismiss
                                   onNegative:(VoidBlock)negativeDismiss
{
    return [[UIAlertView alloc] initWithTitle:@""
                                      message:message
                            cancelButtonTitle:negativeTitle
                            otherButtonTitles:[NSArray arrayWithObject:positiveTitle]
                                    onDismiss:(AlertDismissBlock)positiveDismiss
                                     onCancel:negativeDismiss];
}

+ (UIAlertView *)yesNoAlertWithMessage:(NSString *)message
                                 onYes:(VoidBlock)yesDismiss
                                  onNo:(VoidBlock)noDismiss
{
    return [UIAlertView doubleOptionAlertWithMessage:message
                                 negativeButtonTitle:NSLocalizedString(@"No", @"No in alertview")
                                 positiveButtonTitle:NSLocalizedString(@"Yes", @"Yes in alertview")
                                          onPositive:yesDismiss
                                          onNegative:noDismiss];
}

@end
