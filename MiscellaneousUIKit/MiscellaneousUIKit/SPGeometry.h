//
//  SPGeometry.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import <TargetConditionals.h>

#if TARGET_OS_VISION

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// NSStringfromsp


#pragma mark - SPVector3D
/*
 +[NSValue _mrui_valueWithSPVector3D:]
 -[NSValue _mrui_SPVector3DValue]
 -[NSCoder _uikit_encodeSPVector3D:forKey:]
 -[NSCoder _uikit_decodeSPVector3DForKey:]
 */
struct SPVector3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
    CGFloat _padding_1;
    CGFloat _padding_2;
};
typedef struct SPVector3D SPVector3D;

static inline SPVector3D SPVector3DMake(CGFloat x, CGFloat y, CGFloat z) {
    SPVector3D vector;
    vector.x = x;
    vector.y = y;
    vector.z = z;
    return vector;
}

UIKIT_EXTERN NSString * _NSStringFromSPVector3D(SPVector3D);
UIKIT_EXTERN SPVector3D _SPVector3DFromString(NSString *);


#pragma mark - SPPoint3D

/*
 -[NSCoder ui_decodeCAPoint3DForKey:]
 -[NSCoder ui_encodeCAPoint3D:forKey:]
 */

union SPPoint3D {
    struct {
        CGFloat x;
        CGFloat y;
        CGFloat z;
        CGFloat _padding;
    };
    
    SPVector3D vector;
};

static inline SPPoint3D SPPoint3DMake(CGFloat x, CGFloat y, CGFloat z) {
    SPPoint3D point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

UIKIT_EXTERN NSString * _NSStringFromSPPoint3D(SPPoint3D);
UIKIT_EXTERN SPPoint3D _SPPoint3DFromString(NSString *);


#pragma mark - SPAffineTransform3D

//struct SPAffineTransform3D {
//    CGFloat m11, m12, m13, m14;
//    CGFloat m21, m22, m23, m24;
//    CGFloat m31, m32, m33, m34;
//    CGFloat m41, m42, m43, m44;
//};
typedef CATransform3D SPAffineTransform3D;

UIKIT_EXTERN NSString * _NSStringFromSPAffineTransform3D(SPAffineTransform3D);

#pragma mark - SPRotation3D

struct SPRotation3D {
    CGFloat x, y, z, w, angle;
};

UIKIT_EXTERN NSString * _NSStringFromSPRotation3D(SPRotation3D);

#endif
