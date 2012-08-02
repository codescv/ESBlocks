//
//  UIView+ESAdditions.h
//  ESBlocks
//
//  Created by Chi Zhang on 1/3/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ESAdditions)

/* view hierarchy */
- (void)printChildrenHierarchy;
- (void)removeAllSubViews;

/* first responder */
- (BOOL)findAndResignFirstResponder;
- (UIView *)findFirstResonder;

/* change view position without changing size */
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/* change view size without changing origin */
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

/* loads a view from a nib file.
 * The nib file must have a UIViewController as the file's owner and has an outlet pointing to the view to be loaded.
 */
+ (UIView *)viewFromNibFile:(NSString *)file;

@end
