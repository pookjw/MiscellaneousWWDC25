//
//  Toolbox.h
//  SpatialAudioWatch Watch App
//
//  Created by Jinwoo Kim on 7/13/25.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN BOOL saw_isAudioMixSupported(void);
FOUNDATION_EXTERN AVAudioMix *saw_audioMix(AVAssetTrack *assetTrack, NSData *metadataBlob, NSInteger renderingStyle, Float32 effectIntensity);
FOUNDATION_EXTERN NSData * _Nullable saw_metadataBlob(AVAssetTrack *assetTrack);

NS_ASSUME_NONNULL_END
