//
//  MTNetCacheManager.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTMenoryCache, MTLocationCache;

typedef void (^MTNetCacheBlock)(id data);

@interface MTNetCacheManager : NSObject
{
    MTMenoryCache   *_memoryCache;
    MTLocationCache *_locationCache;
}

@property (nonatomic, assign)   UInt64  maxSize;

+ (MTNetCacheManager*)defaultManager;
+ (NSString*)tempPath;

- (NSData*)fileOfUrl:(NSString*)url;
- (void)setData:(NSData*)data withUrl:(NSString*)url;

- (UIImage*)imageOfUrl:(NSString*)url;
- (void)setImage:(UIImage*)image withUrl:(NSString*)url;

- (void)saveLocationCache;

- (void)cleanLocationCache;
- (void)cleanMemoryCache;

@end
