//
//  ESGridView.h
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESGridView;

@protocol ESGridViewDelegate <NSObject>

- (NSUInteger)numberOfCellsInGridView:(ESGridView *)gridView;
- (UIView *)gridView:(ESGridView *)gridView cellAtIndex:(NSUInteger)index;
- (CGSize)cellSizeForGridView:(ESGridView *)gridView;

@optional
- (NSUInteger)numberOfColumnsInGridView:(ESGridView *)gridView;

@end

@interface ESGridView : UIView

- (void)reloadData;

@property (weak, nonatomic) id <ESGridViewDelegate> delegate;

@end
