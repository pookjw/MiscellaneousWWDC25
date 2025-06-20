//
//  PanGestureRecognizerDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "PanGestureRecognizerDemoViewController.h"
#import "ConfigurationView.h"
#include <objc/message.h>
#include <objc/runtime.h>

#warning TODO

@interface CustomPanGestureRecognizer : NSPanGestureRecognizer
@end
@implementation CustomPanGestureRecognizer

- (void)mouseDragged:(NSEvent *)event {
    [super mouseDragged:event];
}

- (void)mouseCancelled:(NSEvent *)event {
    [super mouseCancelled:event];
}

@end

@interface PanGestureRecognizerDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_gestureView) NSView *gestureView;
@property (retain, nonatomic, readonly, getter=_panGestureRecognizer) CustomPanGestureRecognizer *panGestureRecognizer;
@end

@implementation PanGestureRecognizerDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize gestureView = _gestureView;
@synthesize panGestureRecognizer = _panGestureRecognizer;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_gestureView release];
    [_panGestureRecognizer release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gestureView removeGestureRecognizer:self.panGestureRecognizer];
    });
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.gestureView];
    
    _splitView = splitView;
    return splitView;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSView *)_gestureView {
    if (auto gestureView = _gestureView) return gestureView;
    
    NSView *gestureView = [NSView new];
    [gestureView addGestureRecognizer:self.panGestureRecognizer];
    
    _gestureView = gestureView;
    return gestureView;
}

- (CustomPanGestureRecognizer *)_panGestureRecognizer {
    if (auto panGestureRecognizer = _panGestureRecognizer) return panGestureRecognizer;
    
    CustomPanGestureRecognizer *panGestureRecognizer = [[CustomPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureRecognizerDidTrigger:)];
    
    _panGestureRecognizer = panGestureRecognizer;
    return panGestureRecognizer;
}

- (void)_panGestureRecognizerDidTrigger:(NSPanGestureRecognizer *)sender {
    NSLog(@"%d", sender.state == NSGestureRecognizerStateCancelled);
}

- (void)_reload {
    
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
