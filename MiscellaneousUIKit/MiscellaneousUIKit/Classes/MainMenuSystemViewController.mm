//
//  MainMenuSystemViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "MainMenuSystemViewController.h"
#import "UIMenuSystemElementGroupPreference+String.h"
#include <vector>
#include <ranges>
#include <utility>
#include <objc/runtime.h>
#include <objc/message.h>
#import "UIMenuSystemFindElementGroupConfigurationStyle+String.h"

UIKIT_EXTERN NSString * _UIMenuSystemElementGroupPreferenceDescription(UIMenuSystemElementGroupPreference);

@interface MainMenuSystemViewController ()
@property (retain, nonatomic, readonly, getter=_textView) UITextView *textView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation MainMenuSystemViewController
@synthesize textView = _textView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_textView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (UITextView *)_textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    textView.findInteractionEnabled = YES;
    
    _textView = textView;
    return textView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        UIMainMenuSystemConfiguration * _Nullable _configuration;
        assert(object_getInstanceVariable(UIMainMenuSystem.sharedSystem, "_configuration", reinterpret_cast<void **>(&_configuration)) != NULL);
        
        void(^ _Nullable _buildHandler)(id<UIMenuBuilder> builder);
        assert(object_getInstanceVariable(UIMainMenuSystem.sharedSystem, "_buildHandler", reinterpret_cast<void **>(&_buildHandler)) != NULL);
        
        {
            UIMainMenuSystemConfiguration *copy = [_configuration copy];
            if (copy == nil) copy = [UIMainMenuSystemConfiguration new];
            
            auto configurationsVec = std::vector<std::pair<SEL, SEL>> {
                { @selector(newScenePreference), @selector(setNewScenePreference:) },
                { @selector(documentPreference), @selector(setDocumentPreference:) },
                { @selector(printingPreference), @selector(setPrintingPreference:) },
                { @selector(findingPreference), @selector(setFindingPreference:) },
                { @selector(toolbarPreference), @selector(setToolbarPreference:) },
                { @selector(sidebarPreference), @selector(setSidebarPreference:) },
                { @selector(inspectorPreference), @selector(setInspectorPreference:) },
                { @selector(textFormattingPreference), @selector(setTextFormattingPreference:) },
            }
            | std::views::transform([copy, _buildHandler](std::pair<SEL, SEL> cmds) -> UIMenu * {
                NSUInteger count;
                const UIMenuSystemElementGroupPreference *preferences = allUIMenuSystemElementGroupPreferences(&count);
                
                auto actionsVec = std::views::iota(preferences, preferences + count)
                | std::views::transform([](const UIMenuSystemElementGroupPreference *ptr) { return *ptr; })
                | std::views::transform([copy, cmds, _buildHandler](UIMenuSystemElementGroupPreference preference) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromUIMenuSystemElementGroupPreference(preference) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        reinterpret_cast<void (*)(id, SEL, UIMenuSystemElementGroupPreference)>(objc_msgSend)(copy, cmds.second, preference);
                        [UIMainMenuSystem.sharedSystem setBuildConfiguration:copy buildHandler:_buildHandler];
                    }];
                    
                    action.state = (reinterpret_cast<UIMenuSystemElementGroupPreference (*)(id, SEL)>(objc_msgSend)(copy, cmds.first) == preference) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                UIMenu *menu = [UIMenu menuWithTitle:NSStringFromSelector(cmds.first) children:actions];
                [actions release];
                menu.subtitle = NSStringFromUIMenuSystemElementGroupPreference(reinterpret_cast<UIMenuSystemElementGroupPreference (*)(id, SEL)>(objc_msgSend)(copy, cmds.first));
                
                return menu;
            })
            | std::ranges::to<std::vector<UIMenu *>>();
            
            NSMutableArray<UIMenu *> *children = [[NSMutableArray alloc] initWithObjects:configurationsVec.data() count:configurationsVec.size()];
            
            {
                NSUInteger count;
                const UIMenuSystemFindElementGroupConfigurationStyle *styles = allUIMenuSystemFindElementGroupConfigurationStyles(&count);
                
                auto actionsVec = std::views::iota(styles, styles + count)
                | std::views::transform([](const UIMenuSystemFindElementGroupConfigurationStyle *ptr) { return *ptr; })
                | std::views::transform([copy, _buildHandler](UIMenuSystemFindElementGroupConfigurationStyle style) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromUIMenuSystemFindElementGroupConfigurationStyle(style) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        copy.findingConfiguration.style = style;
                        [UIMainMenuSystem.sharedSystem setBuildConfiguration:copy buildHandler:_buildHandler];
                    }];
                    
                    action.state = (copy.findingConfiguration.style == style) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Finding Configuration" children:actions];
                [actions release];
                
                [children addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Configuration" children:children];
            if (_configuration == nil) {
                menu.subtitle = @"Not set";
            }
            [children release];
            [results addObject:menu];
        }
        
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Custom Build Handler" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                void(^ _Nullable _buildHandler)(id<UIMenuBuilder> builder);
                assert(object_getInstanceVariable(UIMainMenuSystem.sharedSystem, "_buildHandler", reinterpret_cast<void **>(&_buildHandler)) != NULL);
                
                if (_buildHandler == nil) {
                    _buildHandler = [^(id<UIMenuBuilder>  _Nonnull builder) {
                        UIAction *rebuildAction = [UIAction actionWithTitle:@"Rebuild" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            NSLog(@"Rebuild!");
                            [UIMainMenuSystem.sharedSystem setNeedsRebuild];
                        }];
                        
                        UIMenu *menu = [UIMenu menuWithTitle:NSStringFromClass([MainMenuSystemViewController class]) children:@[rebuildAction]];
                        
                        [builder insertSiblingMenu:menu afterMenuForIdentifier:UIMenuFile];
                    } copy];
                } else {
                    [_buildHandler release];
                    _buildHandler = nil;
                }
                
                assert(object_setInstanceVariable(UIMainMenuSystem.sharedSystem, "_buildHandler", _buildHandler) != NULL);
                [UIMainMenuSystem.sharedSystem setNeedsRebuild];
            }];
            
            action.state = (_buildHandler != nil) ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
