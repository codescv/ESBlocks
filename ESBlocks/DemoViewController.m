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

@interface DemoViewController ()

@end

@implementation DemoViewController

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

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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

@end
