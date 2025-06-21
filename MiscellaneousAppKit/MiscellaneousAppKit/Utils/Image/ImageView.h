//
//  ImageView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImageViewContentMode) {
    ImageViewContentModeAspectFit,
    ImageViewContentModeAspectFill
};

@interface ImageView : NSView
@property (retain, nonatomic, nullable) NSImage *image;
@property (assign, nonatomic) ImageViewContentMode contentMode;
@end

NS_ASSUME_NONNULL_END
