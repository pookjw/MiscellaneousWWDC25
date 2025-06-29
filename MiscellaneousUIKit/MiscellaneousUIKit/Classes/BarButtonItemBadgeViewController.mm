//
//  BarButtonItemBadgeViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "BarButtonItemBadgeViewController.h"

#if !TARGET_OS_VISION

@interface BarButtonItemBadgeViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@property (retain, nonatomic, readonly, getter=_indicatorBarButtonItem) UIBarButtonItem *indicatorBarButtonItem;
@end

@implementation BarButtonItemBadgeViewController
@synthesize barButtonItem = _barButtonItem;
@synthesize indicatorBarButtonItem = _indicatorBarButtonItem;

- (void)dealloc {
    [_barButtonItem release];
    [_indicatorBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.navigationItem.rightBarButtonItems = @[self.barButtonItem, self.indicatorBarButtonItem];
    
//    UIBarButtonItemBadge *badge_1 = [UIBarButtonItemBadge badgeWithString:@"Badge!"];
//    badge_1.foregroundColor = UIColor.systemCyanColor;
//    badge_1.backgroundColor = UIColor.blackColor;
//    badge_1.font = [UIFont systemFontOfSize:30.];
//    
//    UIBarButtonItemBadge *badge_2 = [badge_1 copy];
//    assert([badge_1 isEqual:badge_2]);
//    [badge_2 release];
//    
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
//    [archiver encodeObject:badge_1 forKey:@"badge"];
//    [archiver finishEncoding];
//    NSError * _Nullable error = nil;
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:archiver.encodedData error:&error];
//    assert(unarchiver != nil);
//    assert(error == nil);
//    [archiver release];
//    UIBarButtonItemBadge *badge_3 = [unarchiver decodeObjectOfClass:[UIBarButtonItemBadge class] forKey:@"badge"];
//    [unarchiver release];
//    assert([badge_1 isEqual:badge_3]);
//    
//    assert([badge_3.stringValue isEqualToString:@"Badge!"]);
//    assert([badge_3.foregroundColor isEqual:UIColor.systemCyanColor]);
//    assert([badge_3.backgroundColor isEqual:UIColor.blackColor]);
//    assert([badge_3.font isEqual:[UIFont systemFontOfSize:30.]]);
}

- (UIBarButtonItem *)_barButtonItem {
    if (auto barButtonItem = _barButtonItem) return barButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:nil];
    barButtonItem.badge = [UIBarButtonItemBadge badgeWithString:@"Badge!"];
    
    _barButtonItem = barButtonItem;
    return barButtonItem;
}

- (UIBarButtonItem *)_indicatorBarButtonItem {
    if (auto indicatorBarButtonItem = _indicatorBarButtonItem) return indicatorBarButtonItem;
    
    UIBarButtonItem *indicatorBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:nil];
    indicatorBarButtonItem.badge = [UIBarButtonItemBadge indicatorBadge];
    
    _indicatorBarButtonItem = indicatorBarButtonItem;
    return indicatorBarButtonItem;
}

@end

#endif
