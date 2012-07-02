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

@interface ESViewControllerFactory : NSObject

+ (ESViewControllerFactory *)sharedFactory;

- (BOOL)showMessageViewControllerWithRecipients:(NSArray *)recipients
                                           body:(NSString *)body
                                         onSend:(MessageComposeResultBlock)onSend;

- (BOOL)showMailViewControllerWithRecipients:(NSArray *)recipients
                                       title:(NSString *)title
                                        body:(NSString *)body
                                      onSend:(MailComposeResultBlock)onSend;

@end
