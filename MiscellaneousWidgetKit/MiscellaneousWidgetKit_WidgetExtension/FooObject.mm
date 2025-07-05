//
//  FooObject.mm
//  MiscellaneousWidgetKit_WidgetExtension
//
//  Created by Jinwoo Kim on 7/4/25.
//

#import "FooObject.h"
#include <objc/runtime.h>
#include <objc/message.h>

/*
 (lldb) fdmethods _TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject
 <_TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject: 0x1f6377640> (WidgetKit.HostToExtensionXPCInterface):
 in _TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject:
     Class Methods:
     Instance Methods:
         - (id) init; (0x1da71626c)
         - (void) .cxx_destruct; (0x1da7162a4)
         - (void) invalidate; (0x1da723ac4)
         - (void) performCleanup; (0x1da723ac0)
         - (void) pushTokensDidChange:(id)arg1 completion:(^block)arg2; (0x1da718d40)
         - (void) attachPreviewAgentWithFrameworkPath:(id)arg1 endpoint:(id)arg2 handler:(^block)arg3; (0x1da7161cc)
         - (void) getActivitiesWithRequests:(id)arg1 completion:(^block)arg2; (0x1da71a518)
         - (void) getAllCurrentDescriptorsWithCompletion:(^block)arg1; (0x1da710e7c)
         - (void) getAppIntentsXPCListenerEndpointWithCompletion:(^block)arg1; (0x1da7159d4)
         - (void) getControlTemplatesWithRequests:(id)arg1 completion:(^block)arg2; (0x1da7168b8)
         - (void) getCurrentDescriptorsWithCompletion:(^block)arg1; (0x1da710d90)
         - (void) getPlaceholdersWithRequests:(id)arg1 completion:(^block)arg2; (0x1da713e18)
         - (void) getTimelinesWithRequests:(id)arg1 isPreview:(_Bool)arg2 completion:(^block)arg3; (0x1da713eac)
         - (void) getWidgetRelevancesWithRequest:(id)arg1 completion:(^block)arg2; (0x1da71614c)
         - (void) handleURLSessionEventsFor:(id)arg1 completion:(^block)arg2; (0x1da71186c)
         - (void) setControlState:(id)arg1 completion:(^block)arg2; (0x1da7193b8)
         - (void) widgetPushTokensDidChange:(id)arg1 completion:(^block)arg2; (0x1da719fa0)
 (NSObject ...)
 */

@interface MyDescriptorFetchResult : NSObject <NSSecureCoding>
@property (retain, nonatomic) NSMutableArray *widgetDescriptors;
@property (retain, nonatomic) NSMutableArray *controlDescriptors;
@property (retain, nonatomic) NSMutableArray *activityDescriptors;
@end

@implementation MyDescriptorFetchResult

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        NSArray *activityDescriptors = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], objc_lookUpClass("CHSSessionPlatterDescriptor"), nil] forKey:@"activityDescriptors"];
        NSArray *controlDescriptors = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], objc_lookUpClass("CHSControlDescriptor"), nil] forKey:@"controlDescriptors"];
        NSArray *widgetDescriptors = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], objc_lookUpClass("CHSWidgetDescriptor"), nil] forKey:@"widgetDescriptors"];
        
        NSMutableArray *mutableActivityDescriptors = [[NSMutableArray alloc] initWithCapacity:activityDescriptors.count];
        for (id desc in activityDescriptors) {
            id mutableDesc = [desc mutableCopy];
            [mutableActivityDescriptors addObject:mutableDesc];
            [mutableDesc release];
        }
        _activityDescriptors = mutableActivityDescriptors;
        
        NSMutableArray *mutableControlDescriptors = [[NSMutableArray alloc] initWithCapacity:controlDescriptors.count];
        for (id desc in controlDescriptors) {
            id mutableDesc = [desc mutableCopy];
            [mutableControlDescriptors addObject:mutableDesc];
            [mutableDesc release];
        }
        _controlDescriptors = mutableControlDescriptors;
        
        NSMutableArray *mutableWidgetDescriptors = [[NSMutableArray alloc] initWithCapacity:widgetDescriptors.count];
        for (id desc in widgetDescriptors) {
            id mutableDesc = [desc mutableCopy];
            
            NSString *kind = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mutableDesc, sel_registerName("kind"));
            
            if ([kind isEqualToString:@"Static"]) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mutableDesc, sel_registerName("setBackgroundRemovable:"), YES);
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mutableDesc, sel_registerName("setTransparent:"), YES);
                reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(mutableDesc, sel_registerName("setPreferredBackgroundStyle:"), 0x1);
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mutableDesc, sel_registerName("setSupportsAccentedContent:"), YES);
            }
//            BOOL wantsLiveScene = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mutableDesc, sel_registerName("wantsLiveScene"));
//            if (wantsLiveScene) {
//                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mutableDesc, sel_registerName("setTargetLiveSceneBundleIdentifier:"), @"com.apple.mobilesafari");
//            }
//            if (wantsLiveScene) {
//                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mutableDesc, sel_registerName("setSupportsInteraction:"), NO);
//            }
            
            NSLog(@"%@", mutableDesc);
            [mutableWidgetDescriptors addObject:mutableDesc];
            [mutableDesc release];
        }
        _widgetDescriptors = mutableWidgetDescriptors;
    }
    
    return self;
}

- (void)dealloc {
    [_widgetDescriptors release];
    [_controlDescriptors release];
    [_activityDescriptors release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_activityDescriptors forKey:@"activityDescriptors"];
    [coder encodeObject:_controlDescriptors forKey:@"controlDescriptors"];
    [coder encodeObject:_widgetDescriptors forKey:@"widgetDescriptors"];
}

@end


namespace mwk_TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject {

namespace getAllCurrentDescriptorsWithCompletion_ {
void (*original)(id self, SEL _cmd, void (^completion)(id fetchRequest));
void custom(id self, SEL _cmd, void (^completion)(id fetchRequest)) {
    original(self, _cmd, ^(id fetchRequest) {
        NSError * _Nullable error = nil;
        
        NSKeyedArchiver *archiver_1 = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
        [fetchRequest encodeWithCoder:archiver_1];
        
        NSData *data_1 = archiver_1.encodedData;
        [archiver_1 release];
        
        NSKeyedUnarchiver *unarchiver_1 = [[NSKeyedUnarchiver alloc] initForReadingFromData:data_1 error:&error];
        assert(error == nil);
        MyDescriptorFetchResult *myFetchResult = [[MyDescriptorFetchResult alloc] initWithCoder:unarchiver_1];
        [unarchiver_1 release];
        
        NSKeyedArchiver *archiver_2 = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
        [myFetchResult encodeWithCoder:archiver_2];
        [myFetchResult release];
        NSData *data_2 = archiver_2.encodedData;
        [archiver_2 release];
        
        NSKeyedUnarchiver *unarchiver_2 = [[NSKeyedUnarchiver alloc] initForReadingFromData:data_2 error:&error];
        assert(error == nil);
        id updatedFetchResult = [[[fetchRequest class] alloc] initWithCoder:unarchiver_2];
        [unarchiver_2 release];
        
        completion(updatedFetchResult);
        [updatedFetchResult release];
    });
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject"), sel_registerName("getAllCurrentDescriptorsWithCompletion:"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

@implementation FooObject

+ (void)load {
    mwk_TtCC9WidgetKit24WidgetExtensionXPCServer14ExportedObject::getAllCurrentDescriptorsWithCompletion_::swizzle();
}

@end

/*
 spatialChromeStyles = (none);
 spatialSurface = glass;
 wantsLiveScene = NO;
 requestedDataProtection = 2;
 */
