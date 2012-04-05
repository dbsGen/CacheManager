//
//  MTLocationCache.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTLocationCache.h"

#define kFileName   @"data.db"
#define kConfigName @"info.conf"


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
        [_lock lock];
        NSData* artistData = [NSKeyedArchiver archivedDataWithRootObject:_datas];
        [self performSelectorInBackground:@selector(writeFileHandle:)
                               withObject:[NSArray arrayWithObjects:artistData, _filePath, nil]];
        _saveKey = NO;
        [_lock unlock];
    }
}

- (void)writeFileHandle:(NSArray*)array
{
    NSData *data = [array objectAtIndex:0];
    NSString *path = [array objectAtIndex:1];
    [data writeToFile:path
           atomically:YES];
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
        _lock = [[NSCondition alloc] init];
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
    [self addFile:file withData:nil];
}

- (void)addFile:(MTNetCacheElement *)file withData:(NSData *)data
{
    [_lock lock];
    [_datas setObject:file forKey:file.urlString];
    if (!data) {
        data = UIImagePNGRepresentation(file.data);
    }
    [self performSelectorInBackground:@selector(writeFileHandle:)
                           withObject:[NSArray arrayWithObjects:data, file.path, nil]];
    file.size = [data length];
    _saveKey = YES;
    [_lock unlock];
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
    [_lock lock];
    MTNetCacheElement *obj = [_datas objectForKey:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:obj.path error:nil];
    [_datas removeObjectForKey:url];
    _saveKey = YES;
    [_lock unlock];
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
    [_lock lock];
    [_datas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        MTNetCacheElement *tObj = obj;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:tObj.path error:nil];
    }];
    [_datas removeAllObjects];
    _saveKey = YES;
    [_lock unlock];
}

- (void)deleteBeforeDate:(NSDate*)date
{
    [_lock lock];
    NSArray *keys = [_datas allKeys];
    for (NSString *key in keys) {
        MTNetCacheElement *element = [_datas objectForKey:key];
        if (element && [element.date compare:date] == NSOrderedAscending) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:element.path error:nil];
            [_datas removeObjectForKey:key];
        }
    }
    _saveKey = YES;
    [_lock unlock];
}

- (UInt64)size
{
    NSEnumerator *enumerator = [_datas objectEnumerator];
    MTNetCacheElement *obj;
    UInt64 totle = 0;
    while ((obj = [enumerator nextObject])) {
        totle += obj.size;
    }
    return totle;
}

@end
