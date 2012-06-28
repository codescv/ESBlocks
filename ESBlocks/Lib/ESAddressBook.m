//
//  ESAddressBook.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESAddressBook.h"

#import "SynthesizeSingleton.h"

@interface ESContact ()
@property (nonatomic, assign) ABRecordID internalId;
@end

@implementation ESContact

@synthesize name;
@synthesize phoneNumbers;
@synthesize internalId;

- (id)init
{
    self = [super init];
    if (self) {
        self.internalId = kABRecordInvalidID;
    }
    return self;
}

- (NSString *)name
{
    ABAddressBookRef addressbook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressbook, self.internalId);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFRelease(addressbook);

    if (firstName != nil && lastName != nil) {
        return [firstName stringByAppendingString:lastName];
    } else if (firstName != nil) {
        return firstName;
    } else if (lastName != nil) {
        return lastName;
    } else {
        return @"";
    }
}

- (NSArray *)phoneNumbers
{
    ABAddressBookRef addressbook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressbook, self.internalId);
    ABMutableMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    int count = ABMultiValueGetCount(phones);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        ABMultiValueIdentifier identifier = ABMultiValueGetIdentifierAtIndex(phones, i);
        NSString *number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, i);
        NSString *phoneLabel =(__bridge_transfer NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
        CFRelease(locLabel);
        ESPhoneNumber *phoneNumber = [[ESPhoneNumber alloc] init];
        phoneNumber.label = phoneLabel;
        phoneNumber.number = number;
        phoneNumber.identifier = identifier;
        [result addObject:phoneNumber];
    }
    CFRelease(phones);
    CFRelease(addressbook);
    return result;
}

- (UIImage *)portraitThumbnail
{
    return nil;
}

@end

@interface ESContactEditor ()

@property (nonatomic, strong) ESContact *contact;
@property (nonatomic, strong) NSMutableDictionary *editProps;
@property (nonatomic, strong) NSMutableSet *deleteProps;
@property (nonatomic, strong) NSMutableDictionary *addMultiProps;
@property (nonatomic, strong) NSMutableDictionary *editMultiProps;
@property (nonatomic, strong) NSMutableDictionary *deleteMultiProps;

@end

@implementation ESContactEditor

@synthesize contact = _contact;
@synthesize editProps = _editProps;
@synthesize deleteProps = _deleteProps;
@synthesize editMultiProps = _editMultiProps;
@synthesize deleteMultiProps = _deleteMultiProps;
@synthesize addMultiProps = _addMultiProps;

- (id)init
{
    self = [super init];
    if (self) {
        self.editProps = [NSMutableDictionary dictionary];
        self.deleteProps = [NSMutableSet set];
        self.deleteMultiProps = [NSMutableDictionary dictionary];
        self.editMultiProps = [NSMutableDictionary dictionary];
        self.addMultiProps = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)save
{
    ABAddressBookRef addressbook = ABAddressBookCreate();
    ABRecordRef person;
    if (self.contact == nil) {
        // Create new person
        person = ABPersonCreate();
    } else {
        // Update person
        if (self.contact.internalId == kABRecordInvalidID) {
            CFRelease(addressbook);
            return;
        }
        person = ABAddressBookGetPersonWithRecordID(addressbook, self.contact.internalId);
    }
    
    if (person != NULL) {
        [self.deleteProps enumerateObjectsUsingBlock:^(NSNumber *prop, BOOL *stop) {
            ABPropertyID p = [prop intValue];
            ABRecordRemoveValue(person, p, NULL);
        }];
        
        [self.editProps enumerateKeysAndObjectsUsingBlock:^(NSNumber *prop, id val, BOOL *stop) {
            ABPropertyID p = [prop intValue];
            ABRecordSetValue(person, p, (__bridge CFTypeRef)val, NULL);
        }];
        
        [self.editMultiProps enumerateKeysAndObjectsUsingBlock:^(NSNumber *prop, NSArray *val, BOOL *stop) {
            ABPropertyID p = [prop intValue];
            ABMultiValueIdentifier identifier = [[val objectAtIndex:0] intValue];
            NSString *label = [val objectAtIndex:1];
            id value = [val objectAtIndex:2];
            ABMultiValueRef m = ABRecordCopyValue(person, p);
            ABMultiValueRef multi;
            if (m == NULL) {                
                multi = ABMultiValueCreateMutable(ABPersonGetTypeOfProperty(p)); 
            } else {
                multi = ABMultiValueCreateMutableCopy(m);
                CFRelease(m);
            }
            CFIndex index = ABMultiValueGetIndexForIdentifier(multi, identifier);
            CFRelease(multi);
            if (index == kCFNotFound) {
                return;
            }
            if (label != nil) {
                ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)label, index);
            }
            if (value != nil) {
                ABMultiValueReplaceValueAtIndex(multi, (__bridge CFTypeRef)value, index);
            }
            ABRecordSetValue(person, p, multi, NULL);
        }];
        
        [self.addMultiProps enumerateKeysAndObjectsUsingBlock:^(NSNumber *prop, NSArray *val, BOOL *stop) {
            ABPropertyID p = [prop intValue];
            NSString *label = [val objectAtIndex:0];
            id value = [val objectAtIndex:1];
            ABMultiValueRef m = ABRecordCopyValue(person, p);
            ABMultiValueRef multi;
            if (m == NULL) {                
                multi = ABMultiValueCreateMutable(ABPersonGetTypeOfProperty(p)); 
            } else {
                multi = ABMultiValueCreateMutableCopy(m);
                CFRelease(m);
            }
            ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)value, (__bridge CFStringRef)label, NULL);
            ABRecordSetValue(person, p, multi, NULL);
            CFRelease(multi);
        }];
        
        [self.deleteMultiProps enumerateKeysAndObjectsUsingBlock:^(NSNumber *prop, id val, BOOL *stop) {
            ABPropertyID p = [prop intValue];
            ABMultiValueIdentifier identifier = [val intValue];
            ABMultiValueRef m = ABRecordCopyValue(person, p);
            if (m == NULL) {
                return; // return from block
            }
            ABMultiValueRef multi = ABMultiValueCreateMutableCopy(m);
            CFRelease(m);
            CFIndex index = ABMultiValueGetIndexForIdentifier(multi, identifier);
            if (index == kCFNotFound) {
                CFRelease(multi);
                return;
            }
            ABMultiValueRemoveValueAndLabelAtIndex(multi, index);
            ABRecordSetValue(person, p, multi, NULL);
            CFRelease(multi);
        }];
    }
    
    ABAddressBookAddRecord(addressbook, person, NULL);
    ABAddressBookSave(addressbook, NULL);
    CFRelease(addressbook);
}

- (void)deleteSelf
{
    if (self.contact.internalId == kABRecordInvalidID) {
        return;
    }
    
    ABAddressBookRef addressbook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressbook, self.contact.internalId);
    ABAddressBookRemoveRecord(addressbook, person, NULL);
    ABAddressBookSave(addressbook, NULL);
    CFRelease(addressbook);
}

- (void)editProperty:(ABPropertyID)property value:(id)value
{
    [self.editProps setObject:value forKey:[NSNumber numberWithInt:property]];
}

- (void)deleteProperty:(ABPropertyID)property
{
    [self.deleteProps addObject:[NSNumber numberWithInt:property]];
}

- (void)addMultiProperty:(ABPropertyID)property label:(NSString *)label value:(id)value
{
    NSArray *val = [NSArray arrayWithObjects:label, value, nil];
    [self.addMultiProps setObject:val forKey:[NSNumber numberWithInt:property]];

}

- (void)editMultiProperty:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier label:(NSString *)label value:(id)value
{
    NSArray *val = [NSArray arrayWithObjects:[NSNumber numberWithInt:identifier], label, value, nil];
    [self.editMultiProps setObject:val forKey:[NSNumber numberWithInt:property]];
}

- (void)deleteMultiProperty:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self.deleteMultiProps setObject:[NSNumber numberWithInt:identifier] forKey:[NSNumber numberWithInt:property]];
}

@end

@implementation ESPhoneNumber

@synthesize label;
@synthesize number;
@synthesize identifier;

- (id)init
{
    self = [super init];
    if (self) {
        self.identifier = kABMultiValueInvalidIdentifier;
    }
    return self;
}

@end

@implementation ESAddressBook

SYNTHESIZE_SINGLETON_FOR_CLASS(ESAddressBook);

- (id)init
{
    self = [super init];
    if (self) {
        // prevent strange (possibly buggy code by apple) behaviours:
        // if kABPersonPhoneProperty is accessed before any calls to ABAddressBookCreate(), then its value will be zero.
        ABRecordRef addressbook = ABAddressBookCreate();
        CFRelease(addressbook);
    }
    return self;
}

+ (ESAddressBook *)sharedAddressBook
{
    return [self sharedESAddressBook];
}

- (NSArray *)contactsByMatchingPredicate:(ContactPred)pred
{
    ABAddressBookRef addressbook = ABAddressBookCreate();
    NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressbook);
    NSMutableArray *contacts = [NSMutableArray array];
    for (id person in allPeople) {
        ESContact *contact = [[ESContact alloc] init];
        ABRecordRef personRef = (__bridge ABRecordRef)person;
        ABRecordID personId = ABRecordGetRecordID(personRef);
        contact.internalId = personId;
        
        if (pred && pred(contact)) {
            [contacts addObject:contact];            
        }
    }
    CFRelease(addressbook);
    return contacts;
}

- (ESContact *)oneContactMatchingPredicate:(ContactPred)pred
{
    return [[self contactsByMatchingPredicate:pred] lastObject];
}

- (NSArray *)allContacts
{
    return [self contactsByMatchingPredicate:^BOOL(ESContact *contact) {
        return YES;
    }];
}

- (void)editContact:(ESContact *)contact actions:(EditContactBlock)actions
{
    ESContactEditor *editor = [[ESContactEditor alloc] init];
    editor.contact = contact;
    if (actions) {
        actions(editor);
    }
    [editor save];
}

- (void)createContact:(EditContactBlock)actions
{
    [self editContact:nil actions:actions];
}

- (void)deleteContact:(ESContact *)contact
{
    ESContactEditor *editor = [[ESContactEditor alloc] init];
    editor.contact = contact;
    [editor deleteSelf];
}

- (void)enumerateContactsUsingBlock:(EnumContactBlock)block
{
    NSArray *contacts = [self allContacts];
    BOOL stop = NO;
    for (ESContact *contact in contacts) {
        ESAddressBook *addressbook = self;
        block(addressbook, contact, &stop);
        if (stop) {
            break;
        }
    }
}

@end
