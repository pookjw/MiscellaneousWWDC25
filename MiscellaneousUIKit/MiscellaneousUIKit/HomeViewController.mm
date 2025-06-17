//
//  HomeViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "HomeViewController.h"
#import "GlassEffectViewController.h"
#import "ButtonViewController.h"
#import "LiquidLensViewController.h"
#import "TabViewController.h"
#import "ScrollPocketViewController.h"
#import "MiscellaneousUIKit-Swift.h"
#import "ScrollEdgeElementContainerInteractionViewController.h"
#import "BarButtonZoomTransitionViewController.h"
#import "ActionSheetViewController.h"
#import "ToolbarViewController.h"
#import "SplitContentViewController.h"
#import "SearchBarPlacementViewController.h"
#import "SliderViewController.h"
#import "NavigationItemViewController.h"
#import "ColorExposureViewController.h"
#import "ColorLinearExposureViewController.h"
#import "ColorPickerPresenterViewController.h"
#import "ColorWellViewController.h"
#import "PopoverViewController.h"
#import "BackgroundExtensionViewController.h"
#import "BarButtonItemBadgeViewController.h"
#import "NaturalSelectionViewController.h"
#import "WindowControlViewController.h"
#import "SymbolContentTransitionViewController.h"
#import "DeferredMenuElementViewController.h"
#import "MainMenuSystemViewController.h"
#import "KeyCommandsViewController.h"
#import "ShortcutHUDServiceViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>
#import <Accessibility/Accessibility.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface HomeViewController ()
@property (class, nonatomic, readonly, getter=_classes) NSArray<Class> *classes;
@property (nonatomic, readonly, getter=_classes) NSArray<Class> *classes;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation HomeViewController
@synthesize cellRegistration = _cellRegistration;

+ (NSArray<Class> *)_classes {
    return @[
        [ShortcutHUDServiceViewController class],
        [KeyCommandsViewController class],
        [MainMenuSystemViewController class],
        [DeferredMenuElementViewController class],
        [SymbolContentTransitionViewController class],
        [WindowControlViewController class],
        [NaturalSelectionViewController class],
        [BarButtonItemBadgeViewController class],
        [BackgroundExtensionViewController class],
        [PopoverViewController class],
        [ColorWellViewController class],
        [ColorPickerPresenterViewController class],
        [ColorLinearExposureViewController class],
        [ColorExposureViewController class],
        [NavigationItemViewController class],
        [SliderViewController class],
        [SearchBarPlacementViewController class],
        [SplitContentViewController class],
        [ToolbarViewController class],
        [ActionSheetViewController class],
        [BarButtonZoomTransitionViewController class],
        [ScrollEdgeElementContainerInteractionViewController class],
        [CornerMaskingViewController class],
        [ScrollPocketViewController class],
        [TabViewController class],
        [LiquidLensViewController class],
        [ButtonViewController class],
        [GlassEffectViewController class]
    ];
}

- (NSArray<Class> *)_classes {
    NSMutableArray<Class> *classes = [HomeViewController.classes mutableCopy];
    
    return [classes autorelease];
}

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
//        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    __kindof UIViewController *viewController = [KeyCommandsViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    self.navigationItem.title = window.windowScene.session.role;
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, Class _Nonnull _class) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(_class);
        cell.contentConfiguration = contentConfiguration;
        
        cell.accessories = @[
            [[UICellAccessoryOutlineDisclosure new] autorelease]
        ];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:self.classes[indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UIViewController *viewController = [self.classes[indexPath.item] new];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
