//
//  ListViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "ListViewController.h"

@interface ListViewController ()
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation ListViewController
@synthesize cellRegistration = _cellRegistration;

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
//    self.collectionView.topEdgeEffect.hidden = YES;
//    self.collectionView.leftEdgeEffect.hidden = YES;
//    self.collectionView.rightEdgeEffect.hidden = YES;
//    self.collectionView.bottomEdgeEffect.hidden = YES;
    [self _cellRegistration];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = indexPath.description;
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

@end
