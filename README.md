##CacheManager for image

this is a cache tool, it will help you to create a cache system. 
and it will transform image from data on a attached thread using GCD.

##Cache

get the image from cache by:

    - (void)getImageWithUrl:(NSString*)url block:(MTNetCacheBlock)block;


and set image to the cache by:

    - (void)setImage:(UIImage*)image withUrl:(NSString*)url;

##Expired

- you can set the the autoCleanTime and autoClean to make cacheMnager auto clean the image too old.

like:

    MTNetCacheManager *cacheManager = [MTNetCacheManager defaultManager];
    cacheManager.autoCleanTime = timeUpper(30);
    cacheManager.autoClean = YES;
    
timeUpper(30) means 30 days.

- and you can clean all the image which is before a time.

    - (void)removeLocationCacheBefore:(NSDate*)date;

##Memory 

most time you will want to control the image in the memory.

- user maxSize the limit the space used in the memroy.
- cleanMemoryCache to clean all.

##Disk

how to controll the space on the disk?

- saveLocationCacheInfo to save the index of the disk image.
- cleanLocationCache to clean to all image on the disk.
- locationUsed will return size of space used.