
#import "UIImage+Size.h"

@implementation UIImage(Size)

+ (UIImage *)imageWithImage:(UIImage *)image forSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)resizeImage:(UIImage *)image forSize:(CGSize)size OnGlobalQueueWithCmplitionOnMainThread:(nullable void (^)(id _Nullable image))complitionBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *defaultSizedImage = [UIImage imageWithImage:image forSize:CGSizeMake(size.width, size.height)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complitionBlock(defaultSizedImage);
        });
    });
}
@end
