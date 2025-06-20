//
//  ResponderDemoEventView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "ResponderDemoEventView.h"
#include <execinfo.h>
#include <dlfcn.h>
#import "PassthroughTextField.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface ResponderDemoEventView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_label) PassthroughTextField *label;
@property (retain, nonatomic, readonly, getter=_becomeFirstResponderButton) NSButton *becomeFirstResponderButton;
@property (retain, nonatomic, readonly, getter=_resignFirstResponderButton) NSButton *resignFirstResponderButton;
@property (retain, nonatomic, readonly, getter=_tmpButton) NSButton *tmpButton;
@end

@implementation ResponderDemoEventView
@synthesize stackView = _stackView;
@synthesize label = _label;
@synthesize becomeFirstResponderButton = _becomeFirstResponderButton;
@synthesize resignFirstResponderButton = _resignFirstResponderButton;
@synthesize tmpButton = _tmpButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.stackView.frame = self.bounds;
        self.stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:self.stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_label release];
    [_becomeFirstResponderButton release];
    [_resignFirstResponderButton release];
    [_tmpButton release];
    [super dealloc];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.distribution = NSStackViewDistributionFill;
    
    [stackView addArrangedSubview:self.label];
    [stackView addArrangedSubview:self.becomeFirstResponderButton];
    [stackView addArrangedSubview:self.resignFirstResponderButton];
    [stackView addArrangedSubview:self.tmpButton];
    
    [self.label setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    [self.becomeFirstResponderButton setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [self.resignFirstResponderButton setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [self.tmpButton setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    
    _stackView = stackView;
    return stackView;
}

- (PassthroughTextField *)_label {
    if (auto label = _label) return label;
    
    PassthroughTextField *label = [PassthroughTextField wrappingLabelWithString:@""];
    
    _label = [label retain];
    return label;
}

- (NSButton *)_becomeFirstResponderButton {
    if (auto becomeFirstResponderButton = _becomeFirstResponderButton) return becomeFirstResponderButton;
    
    NSButton *becomeFirstResponderButton = [NSButton new];
    becomeFirstResponderButton.title = @"Become First Responsder";
    becomeFirstResponderButton.bezelStyle = NSBezelStyleGlass;
    becomeFirstResponderButton.target = self;
    becomeFirstResponderButton.action = @selector(_becomeFirstResponderButtonDidTrigger:);
    
    _becomeFirstResponderButton = becomeFirstResponderButton;
    return becomeFirstResponderButton;
}

- (NSButton *)_resignFirstResponderButton {
    if (auto resignFirstResponderButton = _resignFirstResponderButton) return resignFirstResponderButton;
    
    NSButton *resignFirstResponderButton = [NSButton new];
    resignFirstResponderButton.title = @"Resign First Responsder";
    resignFirstResponderButton.bezelStyle = NSBezelStyleGlass;
    resignFirstResponderButton.target = self;
    resignFirstResponderButton.action = @selector(_resignFirstResponderButtonDidTrigger:);
    
    _resignFirstResponderButton = resignFirstResponderButton;
    return resignFirstResponderButton;
}

- (NSButton *)_tmpButton {
    if (auto tmpButton = _tmpButton) return tmpButton;
    
    NSButton *tmpButton = [NSButton new];
    tmpButton.title = @"TMP";
    tmpButton.bezelStyle = NSBezelStyleGlass;
    tmpButton.target = self;
    tmpButton.action = @selector(_tmpButtonDidTrigger:);
    
    _tmpButton = tmpButton;
    return tmpButton;
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    
    NSArray<NSTrackingArea *> *trackingAreas = [self.trackingAreas copy];
    for (NSTrackingArea *ta in trackingAreas) {
        if ([ta.owner isEqual:self]) {
            [self removeTrackingArea:ta];
        }
    }
    
    NSTrackingArea *trackingArea = [self _newTrackingArea];
    [self addTrackingArea:trackingArea];
    [trackingArea release];
}

- (NSTrackingArea *)_newTrackingArea {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingCursorUpdate | NSTrackingActiveAlways owner:self userInfo:nil];
    return trackingArea;
}

- (void)_becomeFirstResponderButtonDidTrigger:(NSButton *)sender {
    [self becomeFirstResponder];
}

- (void)_resignFirstResponderButtonDidTrigger:(NSButton *)sender {
    [self resignFirstResponder];
}

- (void)_tmpButtonDidTrigger:(NSButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)mouseDown:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)rightMouseDown:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)otherMouseDown:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseUp:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)rightMouseUp:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)otherMouseUp:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseMoved:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseDragged:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseCancelled:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)scrollWheel:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)rightMouseDragged:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)otherMouseDragged:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseEntered:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)mouseExited:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)keyDown:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)flagsChanged:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)tabletPoint:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)tabletProximity:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)cursorUpdate:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)magnifyWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)rotateWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)swipeWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)beginGestureWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)endGestureWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)smartMagnifyWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)changeModeWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)touchesBeganWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)touchesEndedWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)quickLookWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)pressureChangeWithEvent:(NSEvent *)event {
    [self _eventDidTrigger];
}

- (void)_eventDidTrigger {
    void *buffer[2];
    int count = backtrace(buffer, 2);
    
    if (count < 2) abort();
    
    struct dl_info info;
    assert(dladdr(buffer[1], &info) != 0);
    
    const char *name = info.dli_sname;
    NSLog(@"%s", name);
    self.label.stringValue = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

@end
