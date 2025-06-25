//
//  NSStringFromNSTintProminence.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSTintProminence(NSTintProminence prominence);
MA_EXTERN NSTintProminence NSTintProminenceFromString(NSString *string);
MA_EXTERN const NSTintProminence * allNSTintProminences(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
