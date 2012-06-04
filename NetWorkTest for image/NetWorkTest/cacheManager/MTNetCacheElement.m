//
//  MTNetCacheElement.m
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "MTNetCacheElement.h"

#define kDate       @"date"
#define kUrlString  @"urlString"
#define kPath       @"path"
#define kSize       @"size"

@implementation MTNetCacheElement

@synthesize date = _date, urlString = _urlString, data = _data, path = _path;
@synthesize size = _size;

- (void)dealloc
{
    [_date          release];
    [_urlString     release];
    [_data          release];
    [_path          release];
    [super          dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_date      forKey:kDate];
    [aCoder encodeObject:_urlString forKey:kUrlString];
    [aCoder encodeObject:_path      forKey:kPath];
    [aCoder encodeInt32:_size       forKey:kSize];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:kDate];
        self.urlString = [aDecoder decodeObjectForKey:kUrlString];
        self.path = [aDecoder decodeObjectForKey:kPath];
        self.size = [aDecoder decodeInt32ForKey:kSize];
    }
    return self;
}

@end
