//
//  SplitViewItemAccessoryViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import "SplitViewItemAccessoryViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface SplitViewItemAccessoryViewController ()
@property (retain, nonatomic, readonly, getter=_textField) NSTextField *textField;
@end

@implementation SplitViewItemAccessoryViewController
@synthesize textField = _textField;

- (void)dealloc {
    [_textField release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.textField.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (NSTextField *)_textField {
    if (auto textField = _textField) return textField;
    
    NSTextField *textField = [NSTextField wrappingLabelWithString:@"Test"];
    
    _textField = [textField retain];
    return textField;
}

@end
