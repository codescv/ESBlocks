//
//  NSObject+ESPropertyGeneration.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/21/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ES_PROP_ASSIGN,
    ES_PROP_RETAIN,
    ES_PROP_COPY
} ESPropertyType;

@interface NSObject (ESPropertyGeneration)

+ (void)defineProperty:(NSString *)propName type:(ESPropertyType)type;

@end
