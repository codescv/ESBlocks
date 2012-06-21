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

static NSString *setterToGetter(NSString *setter)
{
    NSUInteger length = [setter length];
    // remove leading 'set(X)' and trailing ':'
    NSString *remainder = [setter substringWithRange:NSMakeRange(4, length - 5)];
    // decapitalize
    NSString *i = [setter substringWithRange:NSMakeRange(3, 1)];
    NSString *iLower = [i lowercaseString];
    NSString *getter = [iLower stringByAppendingString:remainder];
    return getter;
}

static NSString *keyFromSetter(Class class, NSString *setter)
{
    NSString *getter = setterToGetter(setter);
    return keyFromGetter(class, getter);
}

static void setKey(Class class, NSString *propName)
{
    NSString *keyStr = keyFromGetter(class, propName);
    NSLog(@"set key: %@", keyStr);
    if (keys == nil) {
        keys = [[NSMutableDictionary alloc] init];
    }
    [keys setObject:keyStr forKey:keyStr];
}

static void *getKey(Class class, NSString *propName)
{
    if (keys == nil) {
        return nil;
    }
    while (class) {
        NSLog(@"finding in %@", class);
        NSString *keyStr = keyFromGetter(class, propName);
        void *key = (__bridge void *)[keys objectForKey:keyStr];
        if (key) {
            return key;
        }
        class = class_getSuperclass(class);
    }
    return nil;
}

static id dynamicGetter(id self, SEL _cmd)
{
    NSString *sel = NSStringFromSelector(_cmd);
    void *key = getKey([self class], sel);
    id result = [self ivarForKey:key];
    NSLog(@"key %@ result: %@", key, result);
    return result;
}

static void dynamicSetter(id self, SEL _cmd, id obj)
{
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *getter = setterToGetter(sel);
    void *key = getKey([self class], getter);
    [self setIVar:obj forKey:key];
}

+ (void)defineProperty:(NSString *)propName
{
    NSString *getter = propName;
    NSString *setter = [NSString stringWithFormat:@"set%@:", [propName capitalizedString]];
    class_addMethod([self class], NSSelectorFromString(getter), (IMP)dynamicGetter, "@@:");
    class_addMethod([self class], NSSelectorFromString(setter), (IMP)dynamicSetter, "v@:@");
    setKey([self class], propName);
}

- (id)ivarForKey:(void *)key
{
    NSLog(@"ivar for %@", key);
    return objc_getAssociatedObject(self, key);
}

- (void)setIVar:(id)var forKey:(void *)key
{
    NSLog(@"set ivar for %@", key);
    objc_setAssociatedObject(self, key, var, OBJC_ASSOCIATION_RETAIN);
}

@end
