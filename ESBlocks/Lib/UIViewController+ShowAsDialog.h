//
//  UIViewController+ShowAsDialog.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/26/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerAsDialog
@optional
// View Controllers can override these methods to provide behaviours when shown/dismissed as a dialog
- (void)viewWillAppearAsDialog;
- (void)viewDidAppearAsDialog;
- (void)viewWillDisappearAsDialog;
- (void)viewDidDisappearAsDialog;
@end

@interface UIViewController (ShowAsDialog) <UIViewControllerAsDialog>

- (void)showAsDialog;
- (void)dismissDialog;

@end
