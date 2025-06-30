//
//  MRUINotificationsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/30/25.
//

#import "MRUINotificationsViewController.h"
#import "SPGeometry.h"

/*
 recenterWorkspaceWithSceneIdentifier:completion:"
 RealitySimulationServices`-[RSSPlacementService recenterPrimaryWorkspace]
 */

#if TARGET_OS_VISION

@interface MRUINotificationsViewController ()
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_notifications) NSMutableArray<NSNotification *> *notifications;
@end

@implementation MRUINotificationsViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        _notifications = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_cellRegistration release];
    [_notifications release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    NSArray<NSNotificationName> *notificationNames = @[
        @"MRUIWindowSceneDidBeginRepositioningNotification",
        @"MRUIWindowSceneDidEndRepositioningNotification",
        @"_MRUISceneDidChangeRelativeTransformNotification",
        @"MRUIWindowSceneDidBeginSnapToSurfaceNotification",
        @"MRUIWindowSceneDidEndSnapToSurfaceNotification",
        @"MRUIWindowSceneDidChangeSnappingSurfaceClassificationNotification",
        @"MRUIWindowSceneDidBeginBeingOccludedBySystemUINotification",
        @"MRUIWindowSceneDidEndBeingOccludedBySystemUINotification",
        @"_MRUISceneDidUpdateSystemSceneDisplacementNotification"
    ];
    
    for (NSNotificationName name in notificationNames) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_notificationDidPost:) name:name object:nil];
    }
}

- (void)_notificationDidPost:(NSNotification *)notification {
    dispatch_assert_queue(dispatch_get_main_queue());
    if (![self.view.window.windowScene isEqual:notification.object]) return;
        
    [self.collectionView performBatchUpdates:^{
        [_notifications insertObject:notification atIndex:0];
        [self.collectionView insertItemsAtIndexPaths:@[
            [NSIndexPath indexPathForItem:0 inSection:0]
        ]];
    }
                                  completion:^(BOOL finished) {
        
    }];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSNotification * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        
        if ([item.name isEqualToString:@"_MRUISceneDidChangeRelativeTransformNotification"]) {
            NSValue *transformValue = item.userInfo[@"_MRUIScenePreviousRelativeTransformKey"];
            SPAffineTransform3D transform = [transformValue CATransform3DValue];
            contentConfiguration.text = [NSString stringWithFormat:@"%@ (%@)", item.name, _NSStringFromSPAffineTransform3D(transform)];
        } else {
            contentConfiguration.text = item.name;
        }
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _notifications.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:_notifications[indexPath.item]];
}

@end

#endif
