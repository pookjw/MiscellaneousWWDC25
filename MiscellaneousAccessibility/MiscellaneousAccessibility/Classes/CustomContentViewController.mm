//
//  CustomContentViewController.mm
//  MiscellaneousAccessibility
//
//  Created by Jinwoo Kim on 6/28/25.
//

#import "CustomContentViewController.h"
#import <Accessibility/Accessibility.h>

@interface CustomContentView : UIView <AXCustomContentProvider>
@end

@implementation CustomContentView
@synthesize accessibilityCustomContent;
@synthesize accessibilityCustomContentBlock = _accessibilityCustomContentBlock;

- (void)dealloc {
    [_accessibilityCustomContentBlock release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.systemOrangeColor;
        self.accessibilityIdentifier = @"Identifier";
        self.accessibilityLabel = @"Accessibility Label";
        self.isAccessibilityElement = YES;
        
//        self.accessibilityCustomContentBlock = ^NSArray<AXCustomContent *> * _Nullable{
//            AXCustomContent *importantContent_0 = [AXCustomContent customContentWithLabel:@"Label 0" value:@"Value 0"];
//            importantContent_0.importance = AXCustomContentImportanceHigh;
//            
//            AXCustomContent *importantContent_1 = [AXCustomContent customContentWithLabel:@"Label 1" value:@"Value 1"];
//            importantContent_1.importance = AXCustomContentImportanceHigh;
//            
//            return @[
//                importantContent_0,
//                importantContent_1,
//                [AXCustomContent customContentWithLabel:@"Label 2" value:@"Value 2"],
//                [AXCustomContent customContentWithLabel:@"Label 3" value:@"Value 3"]
//            ];
//        };
    }
    
    return self;
}

- (NSArray<AXCustomContent *> *)accessibilityCustomContent {
    AXCustomContent *importantContent_0 = [AXCustomContent customContentWithLabel:@"Label 0" value:@"Value 0"];
    importantContent_0.importance = AXCustomContentImportanceHigh;
    
    AXCustomContent *importantContent_1 = [AXCustomContent customContentWithLabel:@"Label 1" value:@"Value 1"];
    importantContent_1.importance = AXCustomContentImportanceHigh;
    
    return @[
        importantContent_0,
        importantContent_1,
        [AXCustomContent customContentWithLabel:@"Label 2" value:@"Value 2"],
        [AXCustomContent customContentWithLabel:@"Label 3" value:@"Value 3"]
    ];
}

@end

@interface CustomContentViewController ()

@end

@implementation CustomContentViewController

- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    CustomContentView *contentView = [CustomContentView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    [NSLayoutConstraint activateConstraints:@[
        [contentView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [contentView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [contentView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5]
    ]];
    self.view.accessibilityElements = @[contentView];
    [contentView release];
}

@end
