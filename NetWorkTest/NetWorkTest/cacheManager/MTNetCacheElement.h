//
//  MTNetCacheElement.h
//  NetWorkTest
//
//  Created by zrz on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNetCacheElement : NSObject 
<NSCoding>{
    NSDate      *_date;
    NSString    *_urlString,
                *_path;
    NSData      *_data;
}

@property (nonatomic, retain)   NSDate      *date;
@property (nonatomic, retain)   NSString    *urlString,
                                            *path;
@property (nonatomic, retain)   NSData      *data;

@end
