//
//  NaturalSelectionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/16/25.
//

#import "NaturalSelectionViewController.h"

@interface NaturalSelectionViewController () <UITextViewDelegate>
@property (retain, nonatomic, readonly, getter=_textView) UITextView *textView;
@end

@implementation NaturalSelectionViewController
@synthesize textView = _textView;

- (void)dealloc {
    [_textView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITextView *)_textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    textView.backgroundColor = UIColor.systemBackgroundColor;
    textView.text = @"Hello שלום";
    
    textView.delegate = self;
    
    _textView = textView;
    return textView;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"%@", textView.selectedRanges);
}

@end
