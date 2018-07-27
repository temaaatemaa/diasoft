//
//  VKRequest.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "VKRequest.h"
#import "VKAutharisation.h"
#import <AFNetworking.h>

@interface VKRequest()

@property (nonatomic, strong) NSString *token;

@end


@implementation VKRequest

- (NSString *)token
{
    if (!_token)
    {
        _token = [VKAutharisation token];
    }
    return _token;
}

- (void)requestForMethodName:(NSString *)methodName withParametrs:(NSDictionary *)parametrs withComplitionBlock:(nullable void (^)(id _Nullable responseObject))complitionBlock
{
    
    if (!self.token)
    {
        return;
    }
    NSString *requestURL = [@"https://api.vk.com/method/" stringByAppendingString:methodName];
    
    NSMutableDictionary *paramsWithToken = [NSMutableDictionary dictionaryWithDictionary:parametrs];
    paramsWithToken[@"access_token"] = self.token;
    paramsWithToken[@"v"] = @"5.80";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:requestURL parameters:[paramsWithToken copy]
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             complitionBlock(responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}
@end
