//
//  AppDelegate.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"click"
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(clickedAtButton)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(50, 50, 200, 50);
    [self.window addSubview:button];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 300, 300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor grayColor];
    [self.window addSubview:_imageView];
    
    _array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)clickedAtButton
{
    if (_index >= [_array count]) {
        _index = 0;
    }
    [self loadUrl:[_array objectAtIndex:_index]];
    _index ++;
}

- (void)loadUrl:(NSString*)url
{
    NSString *linkString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MTNetCacheManager *manager = [MTNetCacheManager defaultManager];
    UIImage *image = [manager imageOfUrl:linkString];
    if (image) {
        _imageView.image = image;
    }else {
        _imageView.image = nil;
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:linkString]];
        [request setCompletionBlock:^{
            NSData *data = [request responseData];
            _imageView.image = [UIImage imageWithData:data];
            [manager setData:data withUrl:linkString];
        }];
        [request startAsynchronous];
    }
}

@end
