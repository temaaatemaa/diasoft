

#import <UIKit/UIKit.h>

@interface UIImage(Size)

+ (UIImage *)imageWithImage:(UIImage *)image forSize:(CGSize)size;

+ (void)resizeImage:(UIImage *)image forSize:(CGSize)size OnGlobalQueueWithCmplitionOnMainThread:(nullable void (^)(id _Nullable image))complitionBlock;
@end
