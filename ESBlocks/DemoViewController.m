//
//  DemoViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "DemoViewController.h"
#import "UIAlertView+ESBlocks.h"
#import "UIActionSheet+ESBlocks.h"
#import "ESAddressBook.h"

#import "DialogViewController.h"
#import "UIViewController+ShowAsDialog.h"

#import "UIView+ESAdditions.h"
#import "ESComposeViewController.h"
#import "NSObject+ESBlocks.h"

#import "ESKeyboardManager.h"
#import "ESLog.h"

#import "PopupViewController.h"
#import "UIViewController+ShowAsPopup.h"

#import "MobileCoreServices/UTCoreTypes.h"
#import "MobileCoreServices/UTType.h"

#import "GridViewController.h"
#import "ESNavigationController.h"
#import "NavContentViewController.h"

#import "ESViewControllerFactory.h"

@interface DemoViewController ()

@property (strong, nonatomic) ESComposeViewController *composeViewController;
@property (strong, nonatomic) PopupViewController *popUpViewController;

- (IBAction)showUIAlertViewWithBlocks:(id)sender;
- (IBAction)showUIActionSheetWithBlocks:(id)sender;
- (IBAction)showCustomDialog:(id)sender;
- (IBAction)showGridViewController:(id)sender;
- (IBAction)showCustomNavController:(id)sender;
- (IBAction)showMessageViewController:(id)sender;
- (IBAction)showMailViewController:(id)sender;

@end

@implementation DemoViewController

@synthesize composeViewController;
@synthesize popUpViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popUpViewController = [[PopupViewController alloc] init];
    self.popUpViewController.onPhoto = ^{
        [self.popUpViewController dismissPopup];
        [[ESViewControllerFactory sharedFactory] showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary
                                  mediaType:kUTTypeImage
                              allowsEditing:YES
                                     onPick:^(NSDictionary *info) {
                                         NSLog(@"pick: %@", info);
                                     } onCancel:^{
                                         NSLog(@"cancel");
                                     }];
    };
    
    self.composeViewController = [[ESComposeViewController alloc] init];
    self.composeViewController.maxNumberOfLines = 6;
    self.composeViewController.minNumberOfLines = 1;
    self.composeViewController.view.bottom = self.view.height;
    self.composeViewController.onResize = ^{
        CGFloat keyboardTop = [[ESKeyboardManager sharedManager] keyboardTopInView:self.view];
        self.composeViewController.view.bottom = keyboardTop;
    };
    self.composeViewController.text = @"abcdef\ndkdj\nall\n";
    
    self.composeViewController.onAttach = ^{
        CGPoint pt = CGPointMake(self.view.width / 2, self.view.height / 2);
        [self.popUpViewController showAsPopupFromPoint:pt inView:self.view];
    };
    
    self.composeViewController.onSend = ^ {
        [[ESKeyboardManager sharedManager] dismissKeyboard];
        self.composeViewController.text = @"";
    };
    
    [self.view addSubview:self.composeViewController.view];

    [self registerNotification:UIKeyboardWillShowNotification
                    usingBlock:
     ^(NSNotification *notif) {
         CGFloat keyboardTop = [[ESKeyboardManager sharedManager] keyboardTopInView:self.view forNotification:notif];
         [[ESKeyboardManager sharedManager] animateWithKeyboardNotification:notif
                                                                 animations:^{
                                                                     self.composeViewController.view.bottom = keyboardTop;
                                                                 }];
         
     }];
    
    [self registerNotification:UIKeyboardWillHideNotification
                    usingBlock:
     ^(NSNotification *notif) {
         [[ESKeyboardManager sharedManager] animateWithKeyboardNotification:notif
                                                                 animations:^{
                                                                     self.composeViewController.view.bottom = self.view.height;
                                                                 }];
         
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.composeViewController = nil;
    self.popUpViewController = nil;
    [self unregisterNotification:UIKeyboardWillShowNotification];
    [self unregisterNotification:UIKeyboardWillHideNotification];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.composeViewController.maxNumberOfLines = 6;
    } else {
        self.composeViewController.maxNumberOfLines = 2;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    /*for (int i = 0; i < 1000; i++) {
        NSString *number = [NSString stringWithFormat:@"123%d", i];
        NSString *name = [NSString stringWithFormat:@"contact_%d", i];
        [[ESAddressBook sharedAddressBook] createContact:^(ESContactEditor *editor) {
            [editor editProperty:kABPersonFirstNameProperty value:name];
            [editor addMultiProperty:kABPersonPhoneProperty label:@"Test" value:number];
            //[editor editMultiProperty:kABPersonPhoneProperty identifier:0 label:@"test2" value:@"123"];
        }];
    }*/
    
    /*[[ESAddressBook sharedAddressBook] enumerateContactsUsingBlock:^(ESAddressBook *addressbook, ESContact *contact, BOOL *stop) {
        [addressbook deleteContact:contact];
    }];*/
    
    /*NSArray *contacts = [[ESAddressBook sharedAddressBook] contactsByMatchingPredicate:^BOOL(ESContact *contact) {
        if ([contact.name isEqualToString:@"contact_1"]) {
            return YES;
        }
        return NO;
    }];
    
    
    NSLog(@"contacts: %@", contacts);*/
}

- (IBAction)showUIAlertViewWithBlocks:(id)sender 
{
    UIAlertView *av = [UIAlertView alertViewWithTitle:@"Title" 
                                              message:@"This is an alert."
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:[NSArray arrayWithObject:@"OK"]
                                            onDismiss:^(UIAlertView *av, int buttonIndex) {
                                                NSLog(@"dismissed: %d", buttonIndex);
                                            } onCancel:^{
                                                NSLog(@"canceled. "); 
                                            }];
    [av show];
}

- (IBAction)showUIActionSheetWithBlocks:(id)sender 
{
    UIActionSheet *as = [UIActionSheet actionSheetWithTitles:[NSArray arrayWithObjects:@"Option1", @"Option2", nil] 
                                                   onDismiss:^(UIActionSheet *as, int buttonIndex) {
                                                       NSLog(@"dismissed: %d", buttonIndex);
                                                   }];
    [as show];
}

- (IBAction)showCustomDialog:(id)sender
{
    DialogViewController *dvc = [[DialogViewController alloc] init];
    [dvc showAsDialog];
}

- (IBAction)showGridViewController:(id)sender
{
    GridViewController *gvc = [[GridViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (IBAction)showCustomNavController:(id)sender
{
    NavContentViewController *fvc = [[NavContentViewController alloc] init];
    fvc.content = @"first";
    ESNavigationController *nav = [[ESNavigationController alloc] initWithRootViewController:fvc];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (IBAction)showMessageViewController:(id)sender 
{
    [[ESViewControllerFactory sharedFactory] showMessageViewControllerWithRecipients:[NSArray arrayWithObject:@"123"]
                                                                                body:@"test"
                                                                              onSend:^(MFMessageComposeViewController *controller, MessageComposeResult result) {
                                                                                  NSLog(@"result: %d", result);
                                                                              }];
}

- (IBAction)showMailViewController:(id)sender
{
    [[ESViewControllerFactory sharedFactory] showMailViewControllerWithRecipients:[NSArray arrayWithObject:@"123@abc.com"] 
                                                                                                     title:@"Title"
                                                                                                      body:@"body"
                                                                                                    onSend:^(MFMailComposeViewController *controller, MFMailComposeResult result) {
                                                                                                        NSLog(@"result: %d", result);
                                                                                                    }];
}

@end
