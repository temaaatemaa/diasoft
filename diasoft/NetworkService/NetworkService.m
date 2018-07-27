//
//  NetworkService.m
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "NetworkService.h"
#import "AppDelegate.h"

@interface NetworkService()

@property (nonatomic,copy) NSCache *cash;

@end


@implementation NetworkService

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cash = ((AppDelegate *)[UIApplication sharedApplication].delegate).cash;
    }
    return self;
}

-(void)downloadPhotoWithURL:(NSString *)url withComplitionBlock:(void (^)(id _Nullable))complitionBlock
{
    UIImage *cashedImage = [self.cash objectForKey:url];
    if (cashedImage)
    {
        complitionBlock(cashedImage);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:nil];
            UIImage *image = [UIImage imageWithData:data];
            [self.cash setObject:image forKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                complitionBlock(image);
            });
        });
    }
}
@end
