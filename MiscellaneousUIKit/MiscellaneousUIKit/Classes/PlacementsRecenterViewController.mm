//
//  PlacementsRecenterViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/30/25.
//

#import "PlacementsRecenterViewController.h"
#include <notify.h>
#include <objc/message.h>
#include <objc/runtime.h>

#if TARGET_OS_VISION

@interface PlacementsRecenterViewController () {
    int _willRecenterToken;
    int _recenteredToken;
}
@property (retain, nonatomic, readonly, getter=_strings) NSMutableArray<NSString *> *strings;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation PlacementsRecenterViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        _strings = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc {
    notify_cancel(_willRecenterToken);
    notify_cancel(_recenteredToken);
    [_strings release];
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    UICollectionView *collectionView = self.collectionView;
    NSMutableArray<NSString *> *strings = self.strings;
    
    uint32_t result = notify_register_dispatch("com.apple.RealitySimulation.PlacementsWillRecenter", &_willRecenterToken, dispatch_get_main_queue(), ^(int token) {
        [collectionView performBatchUpdates:^{
            [strings insertObject:@"Will Recenter" atIndex:0];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
                                 completion:^(BOOL finished) {
            
        }];
    });
    assert(result == 0);
    
    result = notify_register_dispatch("com.apple.RealitySimulation.PlacementsRecentered", &_recenteredToken, dispatch_get_main_queue(), ^(int token) {
        [collectionView performBatchUpdates:^{
            [strings insertObject:@"Recentered" atIndex:0];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
                                 completion:^(BOOL finished) {
            
        }];
    });
    assert(result == 0);
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item;
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _strings.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:_strings[indexPath.item]];
}

@end

#endif
