//
//  main.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <objc/runtime.h>
#include <objc/message.h>

/*
 _UIScrollPocketInteraction
 _UIParallaxTransitionCardView
 */

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSDictionary *dictionary = @{
            @"PreferredPlacementTarget": @{
                // only single target is allowed!
//                @"Default": @{
//                    @"Alignment": @"Horizontal" // or Vertical
//                }
                
//                @"Anchor": @{
//                    @"Identifier": @"C0C3DBB0-FD7E-4F6F-AFA7-1D350709C5C5"
//                }
                
//                @"Placement": @{
//                    @"Identifier": @"C0C3DBB0-FD7E-4F6F-AFA7-1D350709C5C5"
//                },
                
                @"Hidden": @{}
            },
            @"PreferredLaunchPosition": @{
//                @"Default": @{
//                    @"Distance": @3,
//                    @"MinimumDistance": @3,
//                    @"MaximumDistance": @3
//                },
                
//                @"PlacementRay": @{
//                    @"OriginX": @300,
//                    @"OriginY": @300,
//                    @"OriginZ": @300,
//                    @"DirectionX": @300,
//                    @"DirectionY": @300,
//                    @"DirectionZ": @300,
//                    @"Length": @300,
//                    @"IsLocal": @YES,
//                    @"CoordinateSpace": @"World" // or @"Camera", @"Anchor"
//                }
                
                @"SystemPosition": @{
                    @"Position": @"HomeUI" // or @"AppLaunchedFromHomeUI"
                }
            },
            @"PreferredLaunchSize": @{
                @"Height": @300,
                @"Width": @300,
                @"Depth": @300
            },
            @"PreferredScalingBehavior": @"DynamicScale", // or @"TrueScale"
            @"PreferredSnappingBehavior": @"Aggressive", // or @"Never", @"Nearby"
            @"PreferredRotationBehavior": @"UserFacingAboutX", // or @"None"
            @"PrefersDocking": @YES,
            @"_PreferredChromeOptions": @[
                @"_UISceneChromeOptionsPlacement",
                @"_UISceneChromeOptionsClose",
                @"_UISceneChromeOptionsShare",
                @"_UISceneChromeOptionsTitlebar"
            ]
        };
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
