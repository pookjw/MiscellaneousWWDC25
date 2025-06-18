//
//  PropertiesViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "PropertiesViewController.h"

@interface PropertiesViewController () {
    NSInteger _count;
    BOOL _updateNow;
}
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation PropertiesViewController
@synthesize menuBarButtonItem = _menuBarButtonItem;
@synthesize label = _label;

- (void)dealloc {
    [_menuBarButtonItem release];
    [_label release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (void)updateProperties {
    [super updateProperties];
    self.label.text = @(_count).stringValue;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = UIColor.systemBackgroundColor;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    
    _label = label;
    return label;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        auto loaded = weakSelf;
        if (loaded == nil) {
            completion(@[]);
            return;
        }
        
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"updatePropertiesIfNeeded" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                auto loaded = weakSelf;
                if (loaded == nil) {
                    return;
                }
                loaded->_updateNow = !loaded->_updateNow;
            }];
            action.state = loaded->_updateNow ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Increment" image:[UIImage systemImageNamed:@"plus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                auto loaded = weakSelf;
                if (loaded == nil) {
                    return;
                }
                loaded->_count += 1;
                [loaded setNeedsUpdateProperties];
                if (loaded->_updateNow) {
                    [loaded updatePropertiesIfNeeded];
                }
            }];
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Decrement" image:[UIImage systemImageNamed:@"minus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                auto loaded = weakSelf;
                if (loaded == nil) {
                    return;
                }
                loaded->_count -= 1;
                [loaded setNeedsUpdateProperties];
                if (loaded->_updateNow) {
                    [loaded updatePropertiesIfNeeded];
                }
            }];
            [results addObject:action];
        }
        
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
