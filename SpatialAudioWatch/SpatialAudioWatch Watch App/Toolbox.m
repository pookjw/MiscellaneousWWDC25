//
//  Toolbox.m
//  SpatialAudioWatch Watch App
//
//  Created by Jinwoo Kim on 7/13/25.
//

#import "Toolbox.h"
#include <objc/message.h>
#include <objc/runtime.h>
#include <dlfcn.h>

BOOL saw_isAudioMixSupported(void) {
    void *handle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_NOW);
    void *symbol = dlsym(handle, "MGCopyAnswer");
    NSNumber *answer = ((id (*)(id))symbol)(@"DeviceSupportsAudioMix");
    return answer.boolValue;
}

// disassembly of -[CNAssetSpatialAudioInfo audioMixWithEffectIntensity:renderingStyle:]
AVAudioMix *saw_audioMix(AVAssetTrack *assetTrack, NSData *metadataBlob, NSInteger renderingStyle, Float32 effectIntensity) {
    // x19
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    
    // x20
    AVMutableAudioMixInputParameters *inputParameters = [[AVMutableAudioMixInputParameters alloc] init];
    inputParameters.trackID = assetTrack.trackID;
    
    ((void (*)(id, SEL, Float32, CMTime))objc_msgSend)(inputParameters, sel_registerName("setDialogMixBias:atTime:"), effectIntensity, kCMTimeZero);
    // float가 맞음
    ((void (*)(id, SEL, float, CMTime))objc_msgSend)(inputParameters, sel_registerName("setRenderingStyle:atTime:"), renderingStyle, kCMTimeZero);
    
    // x21
    id audioEffect = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("AVAudioMixCinematicAudioEffect"), sel_registerName("cinematicAudioEffectWithData:"), metadataBlob);
    
    ((void (*)(id, SEL, id))objc_msgSend)(inputParameters, sel_registerName("addEffect:"), audioEffect);
    
    audioMix.inputParameters = @[inputParameters];
    [inputParameters release];
    
    return audioMix;
}


// disassembly of __73+[CNAssetSpatialAudioInfo findAssociatedRemixMetadata:completionHandler:]_block_invoke
NSData *saw_metadataBlob(AVAssetTrack *assetTrack) {
    AVAsset *asset = assetTrack.asset;
    assert(asset != nil);
    
    AVSampleCursor *cursor = [assetTrack makeSampleCursorWithPresentationTimeStamp:kCMTimeZero];
    assert(cursor != nil);
    AVSampleBufferRequest *request = [[AVSampleBufferRequest alloc] initWithStartCursor:cursor];
    AVSampleBufferGenerator *generator = [[AVSampleBufferGenerator alloc] initWithAsset:asset timebase:nil];
    
    request.direction = AVSampleBufferRequestDirectionForward;
    ((void (*)(id, SEL, NSInteger))objc_msgSend)(request, sel_registerName("setPreferredMinSampleCount:"), 1);
    request.maxSampleCount = 1;
    
    NSError * _Nullable error = nil;
    CMSampleBufferRef sampleBuffer = [generator createSampleBufferForRequest:request error:&error];
    [request release];
    [generator release];
    
    AVTimedMetadataGroup *group = [[AVTimedMetadataGroup alloc] initWithSampleBuffer:sampleBuffer];
    CFRelease(sampleBuffer);
    
    NSUInteger index = [group.items indexOfObjectPassingTest:^BOOL(AVMetadataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.identifier isEqualToString:@"mdta/com.apple.quicktime.cinematic-audio"];
    }];
    
    if (index == NSNotFound) {
        [group release];
        return nil;
    }
    
    AVMetadataItem *item = [group.items objectAtIndex:index];
    [group release];
    assert(item != nil);
    
    return item.dataValue;
}
