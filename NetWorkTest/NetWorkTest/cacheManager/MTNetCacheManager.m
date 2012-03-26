//
//  MTNetCacheManager.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTNetCacheManager.h"
#import "MTMenoryCache.h"
#import "MTLocationCache.h"
#import "MTDateFormatter.h"
#import "MTMd5.h"

#define kDateFormat     @"yyyyMMddHHmmssSSS"
#define kTempFileDir    @"temp"
#define kTempExtend     @"tmp"


@implementation MTNetCacheManager

static id __defaultManager;

@synthesize maxSize;

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

- (NSData*)fileOfUrl:(NSString *)urlString
{
    MTNetCacheElement *obj = [_memoryCache fileForUrl:urlString];
    if (obj.data) {
        return obj.data;
    } else {
        obj = [_locationCache fileForUrl:urlString];
        obj.data = [NSData dataWithContentsOfFile:obj.path];
        [_memoryCache addFile:obj];
        return obj.data;
    }
}

- (void)setData:(NSData*)data withUrl:(NSString*)url
{
    NSString *name = MD5String(data);
    MTNetCacheElement *obj = [_locationCache fileForName:name];
    if (!obj) {
        obj = [[[MTNetCacheElement alloc] init] autorelease];
        obj.data = data;
        obj.date = [NSDate date];
        NSString *path = [[[self class] tempPath] stringByAppendingPathComponent:name];
        obj.path = path;
        obj.urlString = url;
        [_locationCache addFile:obj];
    }else {
        obj.data = [NSData dataWithContentsOfFile:obj.path];
        [_memoryCache addFile:obj];
    }
}

- (void)setImage:(UIImage*)image withUrl:(NSString*)url
{
    NSData *data = UIImagePNGRepresentation(image);
    [self setData:data withUrl:url];
}

- (UIImage*)imageOfUrl:(NSString*)url
{
    NSData *data = [self fileOfUrl:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (void)saveLocationCache
{
    [_locationCache save];
}

- (void)cleanLocationCache
{
    [_locationCache deleteAll];
}

- (void)cleanMemoryCache
{
    [_memoryCache deleteAll];
}

@end
