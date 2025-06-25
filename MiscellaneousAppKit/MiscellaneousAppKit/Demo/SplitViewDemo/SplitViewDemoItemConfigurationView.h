//
//  SplitViewDemoItemConfigurationView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SplitViewDemoItemConfigurationView : NSView
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithSplitViewItem:(NSSplitViewItem *)splitViewItem;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
