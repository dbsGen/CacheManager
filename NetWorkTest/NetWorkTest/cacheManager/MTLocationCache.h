//
//  MTLocationCache.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTNetCacheElement.h"

@interface MTLocationCache : NSObject {
    NSMutableDictionary *_datas;
    NSString            *_filePath;
    BOOL                _saveKey;
}

- (id)initWithPath:(NSString*)path;

- (void)setDirPath:(NSString *)path;

- (MTNetCacheElement*)fileForUrl:(NSString*)url;
- (MTNetCacheElement*)fileForName:(NSString*)name;

- (void)addFile:(MTNetCacheElement *)file;
- (void)deleteFileForUrl:(NSString*)url;
- (void)save;
- (void)deleteAll;

@end
