//
//  MTNetCacheManager.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define timeUpper(day) (24 * 3600 * day)

@class MTMenoryCache, MTLocationCache;

typedef void (^MTNetCacheBlock)(id data);

@interface MTNetCacheManager : NSObject
{
    MTMenoryCache   *_memoryCache;
    MTLocationCache *_locationCache;
}

@property (nonatomic, assign)   UInt64  maxSize;    //内存缓存峰值
@property (nonatomic, assign)   BOOL    autoClean;  //是否自动清除缓存信息
@property (nonatomic, assign)   NSTimeInterval  autoCleanTime;  //自动缓存清除时间 默认30天

+ (MTNetCacheManager*)defaultManager;
+ (NSString*)tempPath;          //override this to set your dir path.

- (UIImage*)imageOfUrl:(NSString*)url;
- (void)setImage:(UIImage*)image withUrl:(NSString*)url;

//手动保存磁盘缓存信息,有操作后30秒内会自动缓存一次
- (void)saveLocationCacheInfo;

//清除所有磁盘缓存
- (void)cleanLocationCache;
//清除date之前的缓存信息
- (void)removeLocationCacheBefore:(NSDate*)date;
//磁盘空间使用
- (UInt64)locationUsed;

//清除内存缓存
- (void)cleanMemoryCache;
//内存占用,相同的图片内存使用比磁盘使用要大
- (UInt64)memUsed;

@end
