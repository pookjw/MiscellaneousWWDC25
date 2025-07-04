//
//  impls.m
//  MiscellaneousWidgetKit_WidgetExtension
//
//  Created by Jinwoo Kim on 7/4/25.
//

#import "impls.h"
#include <objc/runtime.h>
#include <objc/message.h>

void mwk_test(void) {
    id connection = ((id (*)(Class, SEL))objc_msgSend)(objc_lookUpClass("CHSChronoServicesConnection"), sel_registerName("sharedInstance"));
    ((void (*)(id, SEL, id, id))objc_msgSend)(connection, sel_registerName("fetchDescriptorsForContainerBundleIdentifier:completion:"), @"com.pookjw.MiscellaneousWidgetKit", ^(id results, id error) {
        
    });
}
