//
//  VideoViewController.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/5/25.
//

#import "VideoViewController.h"

#if TARGET_OS_VISION

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
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_gestureDidTrigger:)];
    [self.view addGestureRecognizer:gesture];
    [gesture release];
}

- (void)_gestureDidTrigger:(UITapGestureRecognizer *)sender {
    AVPlayer *player = ((AVPlayerLayer *)self.view.layer).player;
    
    if (player.rate != 0.f) {
        [player pause];
    } else {
        [player play];
    }
}

@end

#endif
