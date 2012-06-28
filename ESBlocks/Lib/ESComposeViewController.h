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

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) ESComposeViewControllerDelegate onResize;
@property (copy, nonatomic) NSString *text;

@property (assign, nonatomic) NSUInteger maxNumberOfLines;
@property (assign, nonatomic) NSUInteger minNumberOfLines;

- (IBAction)attachClicked:(id)sender;
- (IBAction)sendClicked:(id)sender;

@end
