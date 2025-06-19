//
//  CustomImageDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "CustomImageDemoViewController.h"
#import "ImageView.h"

@implementation CustomImageDemoViewController

- (void)loadView {
    ImageView *imageView = [ImageView new];
    imageView.image = [NSImage imageNamed:@"image"];
    imageView.contentMode = ImageViewContentModeAspectFill;
    self.view = imageView;
    [imageView release];
}

@end
