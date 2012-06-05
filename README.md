##CacheManager for image

this is a image version for CacheManager, it will help you to create a cache system. 
and it will transform image from data on not the main thread using GCD.


get the image from cache by:

    - (void)getImageWithUrl:(NSString*)url block:(MTNetCacheBlock)block;


and set image to the cache by:

    - (void)setImage:(UIImage*)image withUrl:(NSString*)url;
