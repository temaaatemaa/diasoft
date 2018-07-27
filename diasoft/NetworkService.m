//
//  NetworkService.m
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "NetworkService.h"


@interface NetworkService()

@property (nonatomic,copy) NSCache *cash;

@end


@implementation NetworkService

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cash = [[NSCache alloc] init];
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
            [self.cash setObject:[UIImage imageWithData:data] forKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                complitionBlock([UIImage imageWithData:data]);
            });
        });
    }
}
@end
