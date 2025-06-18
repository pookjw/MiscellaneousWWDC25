//
//  KeyCommandsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "KeyCommandsViewController.h"

// https://x.com/_silgen_name/status/1934959693505364105

@interface KeyCommandsViewController ()
@property (retain, nonatomic, readonly, getter=_collectionView) UICollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_dataSource) UICollectionViewDiffableDataSource<NSNumber *, NSString *> *dataSource;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation KeyCommandsViewController
@synthesize collectionView = _collectionView;
@synthesize cellRegistration = _cellRegistration;
@synthesize dataSource = _dataSource;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_collectionView release];
    [_cellRegistration release];
    [_dataSource release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Command 1" image:[UIImage systemImageNamed:@"apple.intelligence"] action:@selector(_command1DidTrigger:) input:@"1" modifierFlags:UIKeyModifierShift propertyList:nil alternates:@[]];
        keyCommand.discoverabilityTitle = @"discoverabilityTitle";
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand keyCommandWithInput:@"2" modifierFlags:UIKeyModifierShift action:@selector(_command2DidTrigger:)];
        keyCommand.repeatBehavior = UIMenuElementRepeatBehaviorNonRepeatable;
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Command 3"
                                                            image:nil
                                                           action:@selector(_command3DidTrigger:)
                                                            input:@"5"
                                                    modifierFlags:UIKeyModifierShift
                                                     propertyList:@"Like User Info"
                                                       alternates:@[
            [UICommandAlternate alternateWithTitle:@"Command 3 (Alt)" action:@selector(_command3AltDidTrigger:) modifierFlags:UIKeyModifierCommand]
        ]];
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Command 4" image:[UIImage systemImageNamed:@"apple.intelligence"] action:@selector(_command4DidTrigger:) input:@"4" modifierFlags:UIKeyModifierShift propertyList:nil alternates:@[]];
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Test" image:[UIImage systemImageNamed:@"apple.intelligence"] action:@selector(_command5DidTrigger:) input:@"=" modifierFlags:UIKeyModifierCommand propertyList:nil alternates:@[]];
        keyCommand.allowsAutomaticLocalization = YES;
        keyCommand.allowsAutomaticMirroring = YES;
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Test 2" image:[UIImage systemImageNamed:@"apple.intelligence"] action:@selector(_command6DidTrigger:) input:@"[" modifierFlags:UIKeyModifierCommand propertyList:nil alternates:@[]];
        keyCommand.allowsAutomaticLocalization = YES;
        keyCommand.allowsAutomaticMirroring = YES;
        [self addKeyCommand:keyCommand];
    }
    
    {
        UIKeyCommand *keyCommand = [UIKeyCommand commandWithTitle:@"Up?" image:[UIImage systemImageNamed:@"apple.intelligence"] action:@selector(_command7DidTrigger:) input:UIKeyInputUpArrow modifierFlags:0 propertyList:nil alternates:@[]];
        keyCommand.allowsAutomaticLocalization = YES;
        keyCommand.allowsAutomaticMirroring = YES;
        keyCommand.wantsPriorityOverSystemBehavior = YES;
        [self addKeyCommand:keyCommand];
    }
}

- (void)_command1DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_command2DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_command3DidTrigger:(UIKeyCommand *)sender {
    NSLog(@"%@", sender.propertyList);
    [self _addExecutedCommand:_cmd];
}

- (void)_command3AltDidTrigger:(UIKeyCommand *)sender {
    NSLog(@"%@", sender.propertyList);
    [self _addExecutedCommand:_cmd];
}

- (void)_command4DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_command5DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_command6DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_command7DidTrigger:(UIKeyCommand *)sender {
    [self _addExecutedCommand:_cmd];
}

- (void)_addExecutedCommand:(SEL)cmd {
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *snapshot = [self.dataSource.snapshot copy];
    
    if (snapshot.sectionIdentifiers.count == 0) {
        [snapshot appendSectionsWithIdentifiers:@[@0]];
    }
    
    NSString *newItem = [NSString stringWithFormat:@"%@ (%@)", NSStringFromSelector(cmd), @(NSDate.now.timeIntervalSince1970).stringValue];
    
    NSString * _Nullable firstItem = snapshot.itemIdentifiers.firstObject;
    if (firstItem == nil) {
        [snapshot appendItemsWithIdentifiers:@[newItem] intoSectionWithIdentifier:@0];
    } else {
        [snapshot insertItemsWithIdentifiers:@[newItem] beforeItemWithIdentifier:firstItem];
    }
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:nil];
    [snapshot release];
}

- (UICollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewLayout];
    
    _collectionView = collectionView;
    return collectionView;
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

- (UICollectionViewDiffableDataSource<NSNumber *,NSString *> *)_dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    UICollectionViewCellRegistration *cellRegistration = self.cellRegistration;
    
    UICollectionViewDiffableDataSource<NSNumber *,NSString *> *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    _dataSource = dataSource;
    return dataSource;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSArray<UIKeyCommand *> *keyCommands = weakSelf.keyCommands;
        NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:keyCommands.count];
        
        for (UIKeyCommand *keyCommand in keyCommands) {
            UIAction *action = [UIAction actionWithTitle:keyCommand.title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}];
//            action.subtitle = keyCommand.modifierFlags;
            action.attributes = UIMenuElementAttributesDisabled;
            [actions addObject:action];
        }
        
        completion(actions);
        [actions release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
