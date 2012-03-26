//
//  MTLocationCache.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTLocationCache.h"

#define kFileName  @"data.db"

@implementation MTLocationCache

static NSMutableArray   *__cache;

- (id)initWithPath:(NSString *)path
{
    self = [self init];
    if (self) {
        [self setDirPath:path];
    }
    return self;
}

+ (void)threadHandle
{
    while (1) {
        sleep(30);
        for (id obj in __cache) {
            [obj save];
        }
    }
}

- (void)save
{
    if (_filePath && _saveKey) {
        NSData* artistData = [NSKeyedArchiver archivedDataWithRootObject:_datas];
        [artistData writeToFile:_filePath atomically:YES];
        _saveKey = NO;
    }
}

- (id)init
{
    if (self = [super init]) {
        if (!__cache) {
            __cache = [[NSMutableArray alloc] init];
            [NSThread detachNewThreadSelector:@selector(threadHandle)
                                     toTarget:[self class]
                                   withObject:nil];
        }
        [__cache addObject:self];
    }
    return self;
}

- (void)dealloc
{
    [_filePath  release];
    [_datas     release];
    [super      dealloc];
}

- (MTNetCacheElement*)fileForUrl:(NSString*)url
{
    MTNetCacheElement *obj = [_datas objectForKey:url];
    obj.date = [NSDate date];
    return obj;
}

- (void)addFile:(MTNetCacheElement *)file
{
    [_datas setObject:file forKey:file.urlString];
    [file.data writeToFile:file.path atomically:YES];
    _saveKey = YES;
}

- (void)setDirPath:(NSString *)path
{
    _filePath = [[path stringByAppendingPathComponent:kFileName] copy];
    _datas = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_filePath]];
    if (!_datas) {
        _datas = [[NSMutableDictionary alloc] init];
    }
}

- (void)deleteFileForUrl:(NSString*)url
{
    MTNetCacheElement *obj = [_datas objectForKey:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:obj.path error:nil];
    [_datas removeObjectForKey:url];
    _saveKey = YES;
}

- (MTNetCacheElement*)fileForName:(NSString *)name
{
    NSEnumerator *enumerator = [_datas objectEnumerator];
    MTNetCacheElement *obj;
    while ((obj = [enumerator nextObject])) {
        if ([[obj.path lastPathComponent] isEqualToString:name]) {
            obj.date = [NSDate date];
            return obj;
        }
    }
    return nil;
}

- (void)deleteAll
{
    [_datas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        MTNetCacheElement *tObj = obj;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:tObj.path error:nil];
    }];
    [_datas removeAllObjects];
    _saveKey = YES;
}

@end
