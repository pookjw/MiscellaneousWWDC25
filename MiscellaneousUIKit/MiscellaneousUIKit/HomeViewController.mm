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

@interface HomeViewController ()
@property (class, nonatomic, readonly, getter=_classes) NSArray<Class> *classes;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation HomeViewController
@synthesize cellRegistration = _cellRegistration;

+ (NSArray<Class> *)_classes {
    return @[
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
    
    __kindof UIViewController *viewController = [NaturalSelectionViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
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
    return HomeViewController.classes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:HomeViewController.classes[indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UIViewController *viewController = [HomeViewController.classes[indexPath.item] new];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
