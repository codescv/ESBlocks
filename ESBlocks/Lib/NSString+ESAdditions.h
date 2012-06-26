//
//  NSString+ESAdditions.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/25/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ESIsEmptyString(Str) ((Str == nil) || [Str isEmptyString])

@interface NSString (ESAdditions)

- (BOOL)isNumeric;
- (BOOL)isEmptyString;
- (BOOL)matchesRegex:(NSString *)pattern;
- (NSString *)stringByMatchingRegex:(NSString *)pattern capture:(int)captureIndex;
- (NSString *)stringByReplacingRegex:(NSString *)pattern withString:(NSString *)replacement;
- (NSArray *)runRegex:(NSString *)pattern;

@end
