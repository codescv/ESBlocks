//
//  ESComposeViewController.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/27/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESComposeViewController;
typedef void (^ESComposeViewControllerDelegate)();

@interface ESComposeViewController : UIViewController
<UITextViewDelegate>

@property (assign, nonatomic) NSUInteger maxNumberOfLines;
@property (assign, nonatomic) NSUInteger minNumberOfLines;
@property (copy, nonatomic) NSString *text;

@property (copy, nonatomic) ESComposeViewControllerDelegate onResize;
@property (copy, nonatomic) ESComposeViewControllerDelegate onAttach;
@property (copy, nonatomic) ESComposeViewControllerDelegate onSend;

- (IBAction)attachClicked:(id)sender;
- (IBAction)sendClicked:(id)sender;

@end
