//
//  PostsManager.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "PostsManager.h"
#import "VKRequest.h"
#import "Post.h"

@interface PostsManager()

@property (nonatomic, strong) VKRequest *vkRequest;
@property (nonatomic, copy) NSString *nextFromValue;

@end

@implementation PostsManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _nextFromValue = @"0";
    }
    return self;
}


#pragma mark - Custom Accessors

- (VKRequest *)vkRequest
{
    if (!_vkRequest)
    {
        _vkRequest = [VKRequest new];
    }
    return _vkRequest;
}


#pragma mark - Public Methods

- (void)getPosts
{
    [self getPostsWithNextFrom:YES];
}

- (void)getNewerPosts
{
    [self getPostsWithNextFrom:NO];
}


#pragma mark - Private Methods

- (void)getPostsWithNextFrom:(BOOL)withNextFrom
{
    NSString *methodName = @"newsfeed.get";
    NSMutableDictionary *parametrs = [NSMutableDictionary new];
    parametrs[@"filter"] = @"post";
    if (withNextFrom)
    {
        parametrs[@"start_from"] = self.nextFromValue;
        NSLog(@"%@", parametrs[@"start_from"]);
    }

    [self.vkRequest requestForMethodName:methodName withParametrs:[parametrs copy] withComplitionBlock:^(id  _Nullable responseObject) {
        NSArray *posts = [self parseResponseToArrayOfPosts:responseObject];
        [self.delegate postsDidLoad:self withPostsArray:posts];
    }];
}

- (NSArray *)parseResponseToArrayOfPosts:(NSDictionary *)dict
{
    dict = dict[@"response"];
    
    NSMutableArray *posts = [NSMutableArray new];
    
    self.nextFromValue = dict[@"next_from"];
    NSArray *items = dict[@"items"];
    NSArray *profiles = dict[@"profiles"];
    NSArray *groups = dict[@"groups"];
    
    for (NSDictionary *item in items)
    {
        Post *post = [Post new];
        post.sourceID = item[@"source_id"];
        post.text = item[@"text"];
        post.postID = item[@"post_id"];
        post.unixDate = item[@"date"];
        
        if (post.sourceID.integerValue > 0)
        {
            //Пост был размещен Userом (sourse_id > 0 а у сообществ < 0)
            for (NSDictionary *profile in profiles)
            {
                //ищем разместивший пост аккаунт в полном списке аккаунтов
                if ([((NSNumber *)profile[@"id"]) isEqualToNumber:((NSNumber *)item[@"source_id"])])
                {
                    post.authorFirstName = profile[@"first_name"];
                    post.authorSecondName = profile[@"last_name"];
                    post.authorFotoURL = profile[@"photo_100"];
                }
            }
        }
        else
        {
            //Пост был размещен сообществом
            for (NSDictionary *group in groups)
            {
                //ищем разместившее пост сообщество в полном списке сообществ
                if (((NSNumber *)group[@"id"]).integerValue == -((NSNumber *)item[@"source_id"]).integerValue)
                {
                    post.authorFirstName = group[@"name"];
                    post.authorFotoURL = group[@"photo_100"];
                }
            }
        }
        post.countOfLikes = item[@"likes"][@"count"];
        post.countOfComments = item[@"comments"][@"count"];
        post.countOfViews = item[@"views"][@"count"];
        post.countOfReposts = item[@"reposts"][@"count"];
        
        NSMutableArray *photosArray = [NSMutableArray new];
        for (NSDictionary *attachment in item[@"attachments"])
        {
            //из вложений выбираем только ФОТО, и каждое фото в массив кладем
            if ([(NSString *)attachment[@"type"] isEqualToString:@"photo"])
            {
                NSDictionary *photoDict = attachment[@"photo"];
                NSArray *sizes = photoDict[@"sizes"];
                [photosArray addObject:[sizes lastObject]];
            }
        }
        post.photoURLArray = [photosArray copy];
        
        if (post.countOfLikes != NULL)
        {
            // не пост!!!
            [posts addObject:post];
        }
    }
    return [posts copy];
}
@end
