//
//  ESComposeViewController.m
//  ESBlocks
//
//  Created by Chi Zhang on 6/27/12.
//  Copyright (c) 2012 Chi Zhang. All rights reserved.
//

#import "ESComposeViewController.h"

#import "ESKeyboardManager.h"
#import "UIView+ESAdditions.h"

#import "ESLog.h"
#undef ES_LOG_LEVEL
#define ES_LOG_LEVEL ES_LOG_LEVEL_ERROR

@interface ESComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) CGFloat minHeight;
@property (assign, nonatomic) CGFloat maxHeight;

@end

@implementation ESComposeViewController

@synthesize textView = _textView;

@synthesize onResize = _onResize;
@synthesize onSend = _onSend;
@synthesize onAttach = _onAttach;

@synthesize maxNumberOfLines = _maxNumberOfLines;
@synthesize minNumberOfLines = _minNumberOfLines;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;

- (id)init
{
    NSLog(@"init escomposes");
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"ESBlocksResources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self = [self initWithNibName:@"ESComposeViewController" bundle:bundle];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _minHeight = 0;
        _maxHeight = MAXFLOAT;
        
        _minNumberOfLines = 1;
        _maxNumberOfLines = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    ESLogt();
}

- (void)viewDidDisappear:(BOOL)animated
{
    ESLogt();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setText:(NSString *)text
{
    self.textView.text = text;
    [self textViewDidChange:self.textView];
}

- (void)reCalculateHeightRanges
{
    [self view];
    
    if (!self.textView) {
        ESLoge(@"calculating height ranges without knowing about current textview width is not possible");
        return;
    }
    
    UITextView *hiddenTextView = [[UITextView alloc] initWithFrame:self.textView.frame];
    hiddenTextView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:hiddenTextView];
    hiddenTextView.font = self.textView.font;
    NSMutableString *str = [NSMutableString stringWithString:@"a"];
    for (int i = 0; i < self.maxNumberOfLines - 1; i++) {
        [str appendString:@"\na"];
    }
    hiddenTextView.text = str;
    [hiddenTextView sizeToFit];
    self.maxHeight = hiddenTextView.contentSize.height;
    
    str = [NSMutableString stringWithString:@"a"];
    for (int i = 0; i + 1 < self.minNumberOfLines; i++) {
        [str appendString:@"\na"];
    }
    hiddenTextView.text = str;
    [hiddenTextView sizeToFit];
    self.minHeight = hiddenTextView.contentSize.height;
    [hiddenTextView removeFromSuperview];
    
    ESLogd(@"min height: %lf max height: %lf");
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    [self reCalculateHeightRanges];
    [self textViewDidChange:self.textView];
}

- (void)setMinNumberOfLines:(NSUInteger)minNumberOfLines
{
    _minNumberOfLines = minNumberOfLines;
    [self reCalculateHeightRanges];
    [self textViewDidChange:self.textView];
}

- (IBAction)attachClicked:(id)sender
{
    if (self.onAttach) {
        self.onAttach();
    }
}

- (IBAction)sendClicked:(id)sender
{
    if (self.onSend) {
        self.onSend();
    }
}

#pragma mark - TextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self view];
    
    if (textView == nil) {
        ESLogd(@"calling did change when textview is nil; ignored.");
        return;
    }
    
    CGFloat height = textView.contentSize.height;
    if (height > self.maxHeight) {
        height = self.maxHeight;
    } else if (height < self.minHeight) {
        height = self.minHeight;
    }
    ESLogd(@"new height: %lf", height);
    
    if (height == self.maxHeight) {
        textView.scrollEnabled = YES;
        if (textView.height < height) {
            [textView flashScrollIndicators];
        }
    } else {
        textView.scrollEnabled = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        textView.height = height;
        self.view.height = height + 8;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.onResize) {
        self.onResize(self);
    }
}

@end
