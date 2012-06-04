//
//  MTNetCacheManager.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "MTNetCacheManager.h"
#import "MTMenoryCache.h"
#import "MTLocationCache.h"
#import "MTMd5.h"

#define kDateFormat     @"yyyyMMddHHmmssSSS"
#define kTempFileDir    @"temp"
#define kTempExtend     @"tmp"
#define kConfigFile     @"info.conf"

#define kAutoClear      @"MTNetCacheAutoClean"
#define kAutoClearTime  @"MTNetCacheAutoCleanTime"

@implementation MTNetCacheManager

static id __defaultManager;

@synthesize maxSize, autoClean = _autoClean, autoCleanTime = _autoCleanTime;

+ (MTNetCacheManager*)defaultManager
{
    if (!__defaultManager) {
        __defaultManager = [[self alloc] init];
    }
    return __defaultManager;
}

static NSString *__tempPath;

+ (NSString*)tempPath
{
    if (!__tempPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        __tempPath = [[path stringByAppendingPathComponent:kTempFileDir] copy];
    }
    return __tempPath;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *tempPath = [[self class] tempPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:tempPath]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:tempPath
                   withIntermediateDirectories:YES 
                                    attributes:nil
                                         error:&error];
            if (error) {
                NSLog(@"net cacher 初始化失败!创建缓存目录失败! \nerror : %@", error);
                return nil;
            }
        }
        _memoryCache = [[MTMenoryCache alloc] init];     
        _locationCache = [[MTLocationCache alloc] initWithPath:tempPath];
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:
                             [[[self class] tempPath] stringByAppendingPathComponent:kConfigFile]];
        BOOL isAutoClean = [[dic objectForKey:kAutoClear] boolValue];
        _autoClean = isAutoClean;
        if (isAutoClean) {
            _autoCleanTime = [[dic objectForKey:kAutoClearTime] doubleValue];
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:- _autoCleanTime];
            [self removeLocationCacheBefore:date];
        }else {
            _autoCleanTime = 0;
        }
    }
    return self;
}

- (void)dealloc
{
    [_memoryCache   release];
    [_locationCache release];
    [super          dealloc];
}

- (UInt64)maxSize
{
    return _memoryCache.maxSize;
}

- (void)setMaxSize:(UInt64)_maxSize
{
    _memoryCache.maxSize = _maxSize;
}

- (void)setImage:(UIImage*)image withUrl:(NSString*)url
{
    NSString *name = MD5String(UIImagePNGRepresentation(image));
    MTNetCacheElement *obj = [_locationCache fileForName:name];
    if (!obj) {
        obj = [[[MTNetCacheElement alloc] init] autorelease];
        obj.data = image;
        obj.date = [NSDate date];
        obj.path = name;
        obj.urlString = url;
        [_locationCache addFile:obj];
    }else {
        obj.data = [UIImage imageWithData:[NSData dataWithContentsOfFile:
                                           [[[self class] tempPath] stringByAppendingPathComponent:obj.path]]];
        [_memoryCache addFile:obj];
    }
}

- (UIImage*)imageOfUrl:(NSString*)url
{
    MTNetCacheElement *obj = [_memoryCache fileForUrl:url];
    if (obj.data) {
        return obj.data;
    } else {
        obj = [_locationCache fileForUrl:url];
        if (obj) {
            obj.data = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[[self class] tempPath] stringByAppendingPathComponent:obj.path]]];
            [_memoryCache addFile:obj];
            return obj.data;
        }else {
            return nil;
        }
    }
}

- (void)saveLocationCacheInfo
{
    [_locationCache save];
}

- (void)cleanLocationCache
{
    [_locationCache deleteAll];
}

- (void)removeLocationCacheBefore:(NSDate*)date
{
    [_locationCache deleteBeforeDate:date];
}

- (void)cleanMemoryCache
{
    [_memoryCache deleteAll];
}

- (void)setAutoClean:(BOOL)autoClean
{
    if (_autoClean == autoClean)
        return;
    _autoClean = autoClean;
    NSString *path = [[[self class] tempPath] stringByAppendingPathComponent:kConfigFile];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSNumber numberWithBool:autoClean]
            forKey:kAutoClear];
    if (autoClean && ![dic objectForKey:kAutoClearTime]) {
        [dic setObject:[NSNumber numberWithDouble:timeUpper(30)]
                forKey:kAutoClearTime];
    }
    [dic writeToFile:path atomically:YES];
}

- (void)setAutoCleanTime:(NSTimeInterval)autoCleanTime
{
    if (_autoCleanTime == autoCleanTime) return;
    _autoCleanTime = autoCleanTime;
    NSString *path = [[[self class] tempPath] stringByAppendingPathComponent:kConfigFile];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    [dic setObject:[NSNumber numberWithDouble:autoCleanTime]
            forKey:kAutoClearTime];
    [dic writeToFile:path atomically:YES];
}

- (UInt64)memUsed
{
    return _memoryCache.size;
}

- (UInt64)locationUsed
{
    return _locationCache.size;
}

@end
