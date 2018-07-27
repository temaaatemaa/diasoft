//
//  VKRequest.h
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VKRequest : NSObject

- (void)requestForMethodName:(NSString *)methodName withParametrs:(NSDictionary *)parametrs withComplitionBlock:(nullable void (^)(id _Nullable responseObject))complitionBlock;

@end

NS_ASSUME_NONNULL_END
