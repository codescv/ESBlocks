//
//  NSString+ESAdditions.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "NSString+ESAdditions.h"

@implementation NSString (ESAdditions)

- (BOOL)isNumeric
{
	NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
	for (int i = 0; i < self.length; i++) {
		if (![numericSet characterIsMember:[self characterAtIndex:i]]) {
			return NO;
		}
	}
	return YES;
}

- (BOOL)isEmptyString
{
    NSCharacterSet *numericSet = [NSCharacterSet whitespaceCharacterSet];
	for (int i = 0; i < self.length; i++) {
		if (![numericSet characterIsMember:[self characterAtIndex:i]]) {
			return NO;
		}
	}
	return YES;
}

- (BOOL)matchesRegex:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"error creating regex pattern %@ error %@", pattern, [error localizedDescription]);
        return NO;
    }
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    NSLog(@"matche: %@", match);
    if (match == nil) {
        return NO;
    }
    return YES;
}

- (NSString *)stringByMatchingRegex:(NSString *)pattern capture:(int)captureIndex
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"error creating regex pattern %@ error %@", pattern, [error localizedDescription]);
        return self;
    }
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    NSRange range = [match rangeAtIndex:captureIndex];
    return [self substringWithRange:range];
}

- (NSString *)stringByReplacingRegex:(NSString *)pattern withString:(NSString *)replacement
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"error creating regex pattern %@ error %@", pattern, [error localizedDescription]);
        return self;
    }
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

- (NSArray *)runRegex:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"error creating regex pattern %@ error %@", pattern, [error localizedDescription]);
        return nil;
    }
    
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *result = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < match.numberOfRanges; i++) {
            NSRange range = [match rangeAtIndex:i];
            NSString *capture = [self substringWithRange:range];
            [result addObject:capture];
        }
    }
    return result;
}

@end
