//
//  UINavigationController+Autorotate.m
//  PresentViewController
//
//  Created by Cortes Saenz, David on 6/5/15.
//  Copyright (c) 2015 Akamai. All rights reserved.
//

#import "UINavigationController+Autorotate.h"
#import "AppDelegate.h"

@implementation UINavigationController (Autorotate)

- (NSUInteger)supportedInterfaceOrientations{
    
    if([[self topViewController] isKindOfClass:[MoreViewController class]])
        return [[self topViewController] supportedInterfaceOrientations];
    
    if([[self topViewController] isKindOfClass:[ViewController class]])
        return UIInterfaceOrientationMaskPortrait;
    
//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL) shouldAutorotate {
    if([[self topViewController] isKindOfClass:[MoreViewController class]])
    return YES;
    else
        return NO;
}

@end
