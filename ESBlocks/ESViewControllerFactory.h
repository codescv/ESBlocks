//
//  ESViewControllerFactory.h
//  ESBlocks
//
//  Created by Chi Zhang on 7/2/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef void (^MessageComposeResultBlock)(MFMessageComposeViewController *controller, MessageComposeResult result);
typedef void (^MailComposeResultBlock)(MFMailComposeViewController *controller, MFMailComposeResult result);
typedef void (^PickMediaDelegateBlock)(NSDictionary *info);
typedef void (^CancelPickMediaDelegteBlock)();

@interface ESViewControllerFactory : NSObject

+ (ESViewControllerFactory *)sharedFactory;

- (BOOL)showMessageViewControllerWithRecipients:(NSArray *)recipients
                                           body:(NSString *)body
                                         onSend:(MessageComposeResultBlock)onSend;

- (BOOL)showMailViewControllerWithRecipients:(NSArray *)recipients
                                       title:(NSString *)title
                                        body:(NSString *)body
                                      onSend:(MailComposeResultBlock)onSend;

// if you want to customize prefs for UIImagePickerController yourself
- (void)showImagePickerController:(UIImagePickerController *)controller
                           onPick:(PickMediaDelegateBlock)onPick
                         onCancel:(CancelPickMediaDelegteBlock)onCancel;

// a convenient way
- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                            mediaType:(CFStringRef)mediaType
                        allowsEditing:(BOOL)allowsEditing
                               onPick:(PickMediaDelegateBlock)onPick
                             onCancel:(CancelPickMediaDelegteBlock)onCancel;

@end
