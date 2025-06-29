//
//  WolfScrollEventViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/29/25.
//

#import "WolfScrollEventViewController.h"

#if TARGET_OS_VISION

#import "WolfScrollEventView.h"

@interface WolfScrollEventViewController ()
@end

@implementation WolfScrollEventViewController

- (void)loadView {
    WolfScrollEventView *view = [WolfScrollEventView new];
    self.view = view;
    [view release];
}

@end

#endif
