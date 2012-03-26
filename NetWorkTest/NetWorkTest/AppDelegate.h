//
//  AppDelegate.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTNetCacheManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView     *_imageView;
    NSArray         *_array;
    NSInteger       _index;
}

@property (strong, nonatomic) UIWindow *window;

@end
