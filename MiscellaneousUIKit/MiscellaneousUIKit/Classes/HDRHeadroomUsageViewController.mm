//
//  HDRHeadroomUsageViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "HDRHeadroomUsageViewController.h"
#import "UIHDRHeadroomUsageLimit+String.h"

typedef NS_ENUM(NSInteger, _UIHDRHeadroomUsageLimit) {
    /// Headroom usage limits are not defined
    _UIHDRHeadroomUsageLimitUnspecified = -1,
    /// Headroom usage limits are in effect, HDR headroom usage should be restricted
    _UIHDRHeadroomUsageLimitEnabled,
    /// Headroom usage limits are disabled, HDR headroom usage is unrestricted.
    _UIHDRHeadroomUsageLimitDisabled,
};

@interface HDRHeadroomUsageViewController ()
@property (retain, nonatomic, nullable, getter=_hdrHeadroomUsageLimitRegistration, setter=_setHDRHeadroomUsageLimit:) id<UITraitChangeRegistration> hdrHeadroomUsageLimitRegistration;
@end

@implementation HDRHeadroomUsageViewController

- (void)dealloc {
    [_hdrHeadroomUsageLimitRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hdrHeadroomUsageLimitRegistration = [self registerForTraitChanges:@[[UITraitHDRHeadroomUsageLimit class]] withTarget:self action:@selector(_hdrHeadroomUsageLimitDidChange:)];
    [self _hdrHeadroomUsageLimitDidChange:self];
}

- (void)_hdrHeadroomUsageLimitDidChange:(HDRHeadroomUsageViewController *)sender {
    NSLog(@"%@", NSStringFromUIHDRHeadroomUsageLimit(self.traitCollection.hdrHeadroomUsageLimit));
    
    if (self.traitCollection.hdrHeadroomUsageLimit == _UIHDRHeadroomUsageLimitUnspecified) {
        self.view.backgroundColor = UIColor.systemGrayColor;
    } else if (self.traitCollection.hdrHeadroomUsageLimit == _UIHDRHeadroomUsageLimitEnabled) {
        self.view.backgroundColor = UIColor.systemRedColor;
    } else if (self.traitCollection.hdrHeadroomUsageLimit == _UIHDRHeadroomUsageLimitDisabled) {
        self.view.backgroundColor = UIColor.systemBlueColor;
    } else {
        self.view.backgroundColor = UIColor.blackColor;
    }
}

@end
