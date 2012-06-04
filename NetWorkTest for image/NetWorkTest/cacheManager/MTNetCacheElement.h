//
//  MTNetCacheElement.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNetCacheElement : NSObject 
<NSCoding>{
    NSDate      *_date;
    NSString    *_urlString,
                *_path;
    UIImage     *_data;
    size_t      _size;
}

@property (nonatomic, retain)   NSDate      *date;
@property (nonatomic, retain)   NSString    *urlString,
                                            *path;
@property (nonatomic, retain)   UIImage     *data;
@property (nonatomic, assign)   size_t      size;

@end
