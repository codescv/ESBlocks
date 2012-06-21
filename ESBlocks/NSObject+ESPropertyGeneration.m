//
//  NSObject+ESPropertyGeneration.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "NSObject+ESPropertyGeneration.h"

#import <objc/runtime.h>

@interface NSObject (ESPropertyGenerationPrivate)
- (id)ivarForKey:(void *)key;
- (void)setIVar:(id)var forKey:(void *)key;
@end

@implementation NSObject (ESPropertyGeneration)

static NSMutableDictionary *keys = nil;

static NSString *keyFromGetter(Class class, NSString *getter)
{
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass(class), getter];
}

static NSString *keyFromSetter(Class class, NSString *setter)
{
    NSUInteger length = [setter length];
    // remove leading 'set(X)' and trailing ':'
    NSString *remainder = [setter substringWithRange:NSMakeRange(4, length - 5)];
    // decapitalize
    NSString *i = [setter substringWithRange:NSMakeRange(3, 1)];
    NSString *iLower = [i lowercaseString];
    NSString *getter = [iLower stringByAppendingString:remainder];
    return keyFromGetter(class, getter);
}

static void setKey(NSString *propName)
{
    NSLog(@"set key: %@", propName);
    if (keys == nil) {
        keys = [[NSMutableDictionary alloc] init];
    }
    [keys setObject:propName forKey:propName];
}

static void *getKey(NSString *propName)
{
    NSLog(@"get key: %@", propName);
    if (keys == nil) {
        return nil;
    }
    return (__bridge void *)[keys objectForKey:propName];
}

static id dynamicGetter(id self, SEL _cmd)
{
    NSString *getter = NSStringFromSelector(_cmd);
    void *key = getKey(keyFromGetter([self class], getter));
    return [self ivarForKey:key];
}

static void dynamicSetter(id self, SEL _cmd, id obj)
{
    NSString *setter = NSStringFromSelector(_cmd);
    void *key = getKey(keyFromSetter([self class], setter));
    [self setIVar:obj forKey:key];
}

+ (void)defineProperty:(NSString *)propName
{
    NSString *getter = propName;
    NSString *setter = [NSString stringWithFormat:@"set%@:", [propName capitalizedString]];
    class_addMethod([self class], NSSelectorFromString(getter), (IMP)dynamicGetter, "@@:");
    class_addMethod([self class], NSSelectorFromString(setter), (IMP)dynamicSetter, "v@:@");
    setKey(keyFromGetter([self class], getter));
}

- (id)ivarForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)setIVar:(id)var forKey:(void *)key
{
    objc_setAssociatedObject(self, key, var, OBJC_ASSOCIATION_RETAIN);
}

@end
