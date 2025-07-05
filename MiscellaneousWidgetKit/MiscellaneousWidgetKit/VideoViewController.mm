//
//  VideoViewController.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/5/25.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface PlayerView : UIView
@end

@implementation PlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@end

@interface VideoViewController ()
@property (retain, nonatomic, nullable) AVPlayerLooper *looper;
@end

@implementation VideoViewController

- (void)dealloc {
    [_looper release];
    [super dealloc];
}

- (void)loadView {
    PlayerView *playerView = [PlayerView new];
    self.view = playerView;
    [playerView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"video" withExtension:UTTypeMPEG4Movie.preferredFilenameExtension];
    assert(url != nil);
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithPlayerItem:item];
    self.looper = [AVPlayerLooper playerLooperWithPlayer:player templateItem:item];
    ((AVPlayerLayer *)self.view.layer).player = player;
    ((AVPlayerLayer *)self.view.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
    [player play];
    [player release];
}

@end
