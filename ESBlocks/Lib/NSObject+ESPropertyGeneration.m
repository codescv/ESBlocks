//
//  NSObject+ESPropertyGeneration.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "NSObject+ESPropertyGeneration.h"
#import "ESLog.h"
#import <objc/runtime.h>

@interface NSObject (ESPropertyGenerationPrivate)
- (id)ivarForKey:(void *)key;
- (void)setIVar:(id)var forKey:(void *)key type:(ESPropertyType)type;
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
    ESLogd(@"set key: %@", keyStr);
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
        ESLogd(@"finding in %@", class);
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
    ESLogd(@"key %@ result: %@", key, result);
    return result;
}

static void assignSetter(id self, SEL _cmd, id obj)
{
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *getter = setterToGetter(sel);
    void *key = getKey([self class], getter);
    [self setIVar:obj forKey:key type:ES_PROP_ASSIGN];
}

static void retainSetter(id self, SEL _cmd, id obj)
{
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *getter = setterToGetter(sel);
    void *key = getKey([self class], getter);
    [self setIVar:obj forKey:key type:ES_PROP_RETAIN];
}

static void copySetter(id self, SEL _cmd, id obj)
{
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *getter = setterToGetter(sel);
    void *key = getKey([self class], getter);
    [self setIVar:obj forKey:key type:ES_PROP_COPY];
}

+ (void)defineProperty:(NSString *)propName type:(ESPropertyType)type
{
    NSString *getter = propName;
    NSString *initial = [getter substringToIndex:1];
    NSString *remain = [getter substringFromIndex:1];
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [initial uppercaseString], remain];
    
    SEL getterSel = NSSelectorFromString(getter);
    SEL setterSel = NSSelectorFromString(setter);
    if (!class_getInstanceMethod([self class], getterSel)) {
        class_addMethod([self class], getterSel, (IMP)dynamicGetter, "@@:");
    } else {
        ESLogd(@"method already defined");
    }
    if (!class_getInstanceMethod([self class], setterSel)) {
        switch (type) {
            case ES_PROP_COPY:
                class_addMethod([self class], setterSel, (IMP)copySetter, "v@:@");
                break;
            case ES_PROP_ASSIGN:
                class_addMethod([self class], setterSel, (IMP)assignSetter, "v@:@");
                break;
            case ES_PROP_RETAIN:
                class_addMethod([self class], setterSel, (IMP)retainSetter, "v@:@");
                break;
            default:
                break;
        }
    } else {
        ESLogd(@"method already defined");
    }
    setKey([self class], propName);
}

- (id)ivarForKey:(void *)key
{
    ESLogd(@"ivar for %@", key);
    return objc_getAssociatedObject(self, key);
}

- (void)setIVar:(id)var forKey:(void *)key type:(ESPropertyType)type
{
    ESLogd(@"set ivar for %@", key);
    objc_AssociationPolicy policy = [self typeToPolicy:type];
    objc_setAssociatedObject(self, key, var, policy);
}

- (objc_AssociationPolicy)typeToPolicy:(ESPropertyType)type
{
    switch (type) {
        case ES_PROP_COPY:
            return OBJC_ASSOCIATION_COPY;
        case ES_PROP_ASSIGN:
            return OBJC_ASSOCIATION_ASSIGN;
        case ES_PROP_RETAIN:
            return OBJC_ASSOCIATION_RETAIN;
        default:
            return OBJC_ASSOCIATION_COPY;
    }
}

@end
