//
//  SuppressHighDynamicRangeContentViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "SuppressHighDynamicRangeContentViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface SuppressHighDynamicRangeContentViewController ()

@end

@implementation SuppressHighDynamicRangeContentViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_suppressingHighDynamicRangeContentDidChange:) name:NSApplicationShouldBeginSuppressingHighDynamicRangeContentNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_suppressingHighDynamicRangeContentDidChange:) name:NSApplicationShouldEndSuppressingHighDynamicRangeContentNotification object:nil];
    
    [self _suppressingHighDynamicRangeContentDidChange:nil];
}

- (void)_suppressingHighDynamicRangeContentDidChange:(NSNotification *)notification {
    if (NSApp.applicationShouldSuppressHighDynamicRangeContent) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("setBackgroundColor:"), NSColor.systemPinkColor);
    } else {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("setBackgroundColor:"), NSColor.systemBlueColor);
    }
    
    NSLog(@"applicationShouldSuppressHighDynamicRangeContent: %d", NSApp.applicationShouldSuppressHighDynamicRangeContent);
}

@end
