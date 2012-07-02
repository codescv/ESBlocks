//
//  ESViewControllerFactory.m
//  ESBlocks
//
//  Created by Chi Zhang on 7/2/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESViewControllerFactory.h"
#import "UIViewController+ESAdditions.h"

#import "SynthesizeSingleton.h"

@interface ESMessageViewControllerDelegate : NSObject <MFMessageComposeViewControllerDelegate> 

@property (copy, nonatomic) MessageComposeResultBlock resultBlock;

@end

@implementation ESMessageViewControllerDelegate

@synthesize resultBlock = _resultBlock;

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (self.resultBlock) {
        self.resultBlock(controller, result);
    }
    [controller dismissAsModalViewControllerAnimated:YES];
    self.resultBlock = nil;
}

@end

@interface ESMailViewControllerDelegate : NSObject <MFMailComposeViewControllerDelegate> 

@property (copy, nonatomic) MailComposeResultBlock resultBlock;

@end

@implementation ESMailViewControllerDelegate

@synthesize resultBlock = _resultBlock;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (self.resultBlock) {
        self.resultBlock(controller, result);
    }
    [controller dismissAsModalViewControllerAnimated:YES];
    self.resultBlock = nil;
}

@end


@interface ESViewControllerFactory ()

@property (strong, nonatomic) ESMessageViewControllerDelegate *messageVCDelegate;
@property (strong, nonatomic) ESMailViewControllerDelegate *mailVCDelegate;

@property (readonly, nonatomic) UIViewController *presentingViewController;

@end

@implementation ESViewControllerFactory

@synthesize messageVCDelegate = _messageVCDelegate;
@synthesize mailVCDelegate = _mailVCDelegate;

SYNTHESIZE_SINGLETON_FOR_CLASS(ESViewControllerFactory);

+ (ESViewControllerFactory *)sharedFactory
{
    return [ESViewControllerFactory sharedESViewControllerFactory];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.messageVCDelegate = [[ESMessageViewControllerDelegate alloc] init];
        self.mailVCDelegate = [[ESMailViewControllerDelegate alloc] init];
    }
    return self;
}

- (UIViewController *)presentingViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (BOOL)showMessageViewControllerWithRecipients:(NSArray *)recipients
                                           body:(NSString *)body
                                         onSend:(MessageComposeResultBlock)onSend
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
        mcvc.body = body;
        mcvc.recipients = recipients;
        mcvc.messageComposeDelegate = self.messageVCDelegate;
        self.messageVCDelegate.resultBlock = onSend;
        [self.presentingViewController presentModalViewController:mcvc animated:YES];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)showMailViewControllerWithRecipients:(NSArray *)recipients
                                       title:(NSString *)title
                                        body:(NSString *)body
                                      onSend:(MailComposeResultBlock)onSend
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        [mcvc setSubject:title];
        [mcvc setToRecipients:recipients];
        [mcvc setMessageBody:body isHTML:NO];
        mcvc.mailComposeDelegate = self.mailVCDelegate;
        self.mailVCDelegate.resultBlock = onSend;
        [self.presentingViewController presentModalViewController:mcvc animated:YES];
        return YES;
    } else {
        return NO;
    }
}

@end
