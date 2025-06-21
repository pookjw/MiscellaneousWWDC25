//
//  ImageView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "ImageView.h"

@implementation ImageView

- (void)dealloc {
    [_image release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSImage *image = self.image;
    if (image == nil) return;
    
    NSSize imageSize = image.size;
    NSRect viewBounds = self.bounds;
    
    CGFloat imageRatio = imageSize.width / imageSize.height;
    CGFloat viewRatio = NSWidth(viewBounds) / NSHeight(viewBounds);
    
    
    if (self.contentMode == ImageViewContentModeAspectFit) {
        if (imageRatio < viewRatio) {
            CGFloat width = imageSize.width * (NSHeight(viewBounds) / imageSize.height);
            [image drawInRect:NSMakeRect(viewBounds.origin.x + (viewBounds.size.width - width) * 0.5,
                                         viewBounds.origin.y,
                                         width,
                                         viewBounds.size.height)];
        } else {
            CGFloat height = imageSize.height * (NSWidth(viewBounds) / imageSize.width);
            [image drawInRect:NSMakeRect(viewBounds.origin.x,
                                         (viewBounds.origin.y + (viewBounds.size.height - height) * 0.5),
                                         viewBounds.size.width,
                                         height)];
        }
    } else if (self.contentMode == ImageViewContentModeAspectFill) {
        if (imageRatio < viewRatio) {
            CGFloat scaledHeight = imageSize.height * (NSWidth(viewBounds) / imageSize.width);
            
            [image drawInRect:NSMakeRect(viewBounds.origin.x,
                                         (viewBounds.origin.y + (viewBounds.size.height - scaledHeight) * 0.5),
                                         viewBounds.size.width,
                                         scaledHeight)];
        } else {
            CGFloat scaledWidth = imageSize.width * (NSHeight(viewBounds) / imageSize.height);
            
            [image drawInRect:NSMakeRect(viewBounds.origin.x + (viewBounds.size.width - scaledWidth) * 0.5,
                                         viewBounds.origin.y ,
                                         scaledWidth,
                                         viewBounds.size.height)];
        }
    }
    
}

- (void)setImage:(NSImage *)image {
    [_image release];
    _image = [image retain];
    self.needsDisplay = YES;
}

- (void)setContentMode:(ImageViewContentMode)contentMode {
    _contentMode = contentMode;
    self.needsDisplay = YES;
}

@end
