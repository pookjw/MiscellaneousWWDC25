//
//  DeferredMenuElementViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "DeferredMenuElementViewController.h"

@interface DeferredMenuElementViewController ()

@end

@implementation DeferredMenuElementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (UIDeferredMenuElementProvider *)providerForDeferredMenuElement:(UIDeferredMenuElement *)deferredElement {
    if ([deferredElement.identifier isEqualToString:@"Deferred Element"]) {
        return [UIDeferredMenuElementProvider providerWithElementProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            UIAction *resolvedAction = [UIAction actionWithTitle:@"Resolved" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                NSLog(@"Resolved");
            }];
            
            completion(@[resolvedAction]);
        }];
    } else {
        return nil;
    }
}

@end
