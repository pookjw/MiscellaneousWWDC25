//
//  MyWidgetCenter.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "MyWidgetCenter.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface MyWidgetCenter ()
@property (retain, nonatomic, readonly, getter=_widgetCenterConnection) NSXPCConnection *widgetCenterConnection;
@end

@implementation MyWidgetCenter

+ (MyWidgetCenter *)sharedInstance {
    static MyWidgetCenter *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MyWidgetCenter new];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _widgetCenterConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.chrono.widgetcenterconnection", 0);
        _widgetCenterConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"WidgetKit.WidgetCenterConnection_Remote")];
        
        NSXPCInterface *remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"WidgetKit.WidgetCenterConnection_Host")];
        [remoteObjectInterface setClasses:[NSSet setWithObjects:objc_lookUpClass("CHSWidget"), [NSArray class], nil] forSelector:sel_registerName("_loadCurrentConfigurations:") argumentIndex:0 ofReply:YES];
        _widgetCenterConnection.remoteObjectInterface = remoteObjectInterface;
        
        _widgetCenterConnection.invalidationHandler = ^{
            abort();
        };
        [_widgetCenterConnection activate];
    }
    
    return self;
}

- (void)dealloc {
    [_widgetCenterConnection invalidate];
    [_widgetCenterConnection release];
    [super dealloc];
}

- (void)reloadAllTimelines:(void (^)(NSError * _Nullable))completion {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadAllTimelines:"), ^(NSError * _Nullable error) {
        if (completion != nil) {
            completion(error);
        }
    });
}

- (void)loadCurrentConfigurations:(void (^)(NSArray * _Nullable, NSError * _Nullable))completion {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.widgetCenterConnection.remoteObjectProxy, sel_registerName("_loadCurrentConfigurations:"), ^(NSArray *configurations, NSError * _Nullable error) {
        if (completion != nil) {
            completion(configurations, error);
        }
    });
}

- (void)reloadAllTimelinesOfKind:(NSString *)kind completion:(void (^)(NSError * _Nullable))completion {
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(self.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadTimelinesOfKind:completion:"), kind, ^(NSError * _Nullable error) {
        if (completion != nil) {
            completion(error);
        }
    });
}

- (void)reloadAllTimelinesOfKind:(NSString *)kind inBundle:(NSString *)bundle completion:(void (^)(NSError * _Nullable))completion {
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(self.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadTimelinesOfKind:inBundle:completion:"), kind, bundle, ^(NSError * _Nullable error) {
        if (completion != nil) {
            completion(error);
        }
    });
}

- (void)invalidateConfigurationRecommendationsInBundle:(NSString *)bundle completion:(void (^)(NSError * _Nullable))completion {
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(self.widgetCenterConnection.remoteObjectProxy, sel_registerName("invalidateConfigurationRecommendationsInBundle:completion:"), bundle, ^(NSError * _Nullable error) {
        if (completion != nil) {
            completion(error);
        }
    });
}

@end
