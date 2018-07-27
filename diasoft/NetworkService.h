//
//  NetworkService.h
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NetworkService : NSObject


- (void)downloadPhotoWithURL:(NSString *)url withComplitionBlock:(nullable void (^)(id _Nullable image))complitionBlock;

@end

NS_ASSUME_NONNULL_END
