//
//  PostsManager.h
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PostsManager;

NS_ASSUME_NONNULL_BEGIN


@protocol PostsManagerDelegate

- (void)postsDidLoad:(PostsManager *)postManager withPostsArray:(NSArray *)postsArray;

@end


@interface PostsManager : NSObject

- (void)getPosts;
/*
 По Выполнению вызывается метод делегата
 */


- (void)getNewerPosts;
/*
 По Выполнению вызывается метод делегата
 */

@property (nonatomic, weak) id<PostsManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
