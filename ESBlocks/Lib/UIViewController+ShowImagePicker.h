//
//  UIViewController+ShowImagePicker.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ESPickMediaDelegate)(NSDictionary *info);
typedef void (^ESCancelPickMediaDelegte)();

@interface UIViewController (ShowImagePicker)

// if you want to customize prefs for UIImagePickerController yourself
- (void)showImagePickerController:(UIImagePickerController *)controller
                           onPick:(ESPickMediaDelegate)onPick
                         onCancel:(ESCancelPickMediaDelegte)onCancel;

// a convenient way
- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                            mediaType:(CFStringRef)mediaType
                        allowsEditing:(BOOL)allowsEditing
                               onPick:(ESPickMediaDelegate)onPick
                             onCancel:(ESCancelPickMediaDelegte)onCancel;

@end
