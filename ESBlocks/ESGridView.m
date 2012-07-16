//
//  ESGridView.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/28/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESGridView.h"

#import "UIView+ESAdditions.h"

@interface ESGridView ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ESGridView

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)reloadData
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    NSUInteger nCells = [self.delegate numberOfCellsInGridView:self];
    CGSize cellSize = [self.delegate cellSizeForGridView:self];
    NSUInteger nColumns;
    if ([self.delegate respondsToSelector:@selector(numberOfColumnsInGridView:)]) {
        nColumns = [self.delegate numberOfColumnsInGridView:self];
    } else {
        nColumns = (NSUInteger) (self.scrollView.width / cellSize.width);
    }
    
    [self.scrollView removeAllSubViews];
    
    for (int i = 0; i < nCells; i++) {
        UIView *cell = [self.delegate gridView:self cellAtIndex:i];
        CGFloat xOffset = (i % nColumns) * cellSize.width;
        CGFloat yOffset = (i / nColumns) * cellSize.height;
        CGPoint offset = CGPointMake(xOffset, yOffset);
        cell.size = cellSize;
        cell.origin = offset;
        [self.scrollView addSubview:cell];
    }
    
    NSUInteger nRows = nCells % nColumns == 0 ? nCells / nColumns : nCells % nColumns;
    CGFloat height = nRows * cellSize.height;
    CGFloat width = nColumns * cellSize.width;
    self.scrollView.contentSize = CGSizeMake(width, height);
    
    //NSLog(@"height: %lf height: %lf height: %lf", height, cellSize.height, self.scrollView.height);
}

@end
