//
//  ESAddressBook.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>


@interface ESContact : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *phoneNumbers;
@property (nonatomic, readonly) UIImage *portraitThumbnail;

@end

@class ESPhoneNumber;
@interface ESContactEditor : NSObject

// Note: no matter what sequence they are called, deletes are applied before edits within
// a single transaction.
- (void)editProperty:(ABPropertyID)property value:(id)value;
- (void)deleteProperty:(ABPropertyID)property;

- (void)editMultiProperty:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier label:(NSString *)label value:(id)value;
- (void)deleteMultiProperty:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
- (void)addMultiProperty:(ABPropertyID)property label:(NSString *)label value:(id)value;

@end

@interface ESPhoneNumber : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) ABMultiValueIdentifier identifier;

@end

@class ESAddressBook;
typedef BOOL (^ContactPred)(ESContact *contact);
typedef void (^EditContactBlock)(ESContactEditor *editor);
typedef void (^EnumContactBlock)(ESAddressBook *addressbook, ESContact *contact, BOOL *stop);

@interface ESAddressBook : NSObject

+ (ESAddressBook *)sharedAddressBook;

- (void)editContact:(ESContact *)contact actions:(EditContactBlock)actions;
- (void)createContact:(EditContactBlock)actions;
- (void)deleteContact:(ESContact *)contact;

- (NSArray *)allContacts;
- (ESContact *)oneContactMatchingPredicate:(ContactPred)pred;
- (NSArray *)contactsByMatchingPredicate:(ContactPred)pred;

- (void)enumerateContactsUsingBlock:(EnumContactBlock)block;

@end
