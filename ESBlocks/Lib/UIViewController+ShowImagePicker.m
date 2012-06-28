//
//  UIViewController+ShowImagePicker.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "UIViewController+ShowImagePicker.h"
#import "NSObject+ESBlocks.h"

@interface ESImagePickerControllerDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic) ESPickMediaDelegate onPick;
@property (copy, nonatomic) ESCancelPickMediaDelegte onCancel;

@end

@implementation ESImagePickerControllerDelegate

@synthesize onPick = _onPick;
@synthesize onCancel = _onCancel;

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.onCancel) {
        self.onCancel();
    }
    self.onCancel = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.onPick) {
        self.onPick(info);
    }
    self.onPick = nil;
}

@end

@implementation UIViewController (ShowImagePicker)

static ESImagePickerControllerDelegate *__image_picker_delegate;
static UIImagePickerController *__picker;

+ (void)load
{
    __image_picker_delegate = [[ESImagePickerControllerDelegate alloc] init];
}

- (void)showImagePickerController:(UIImagePickerController *)controller
                           onPick:(ESPickMediaDelegate)onPick
                         onCancel:(ESCancelPickMediaDelegte)onCancel
{
    __picker = controller;
    __image_picker_delegate.onPick = onPick;
    __image_picker_delegate.onCancel = onCancel;
    __picker.delegate = __image_picker_delegate;
    [self presentModalViewController:__picker animated:YES];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                            mediaType:(CFStringRef)mediaType
                        allowsEditing:(BOOL)allowsEditing
                               onPick:(ESPickMediaDelegate)onPick
                             onCancel:(ESCancelPickMediaDelegte)onCancel
{
    if (__picker == nil) {
        NSLog(@"nil...");
        __picker = [[UIImagePickerController  alloc] init];
    }
    __picker.sourceType = sourceType;
    __picker.mediaTypes = [NSArray arrayWithObjects:(__bridge NSString *)mediaType, nil];
    __picker.allowsEditing = allowsEditing;
    [self showImagePickerController:__picker
                             onPick:onPick
                           onCancel:onCancel];
}


@end
