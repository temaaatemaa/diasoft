//
//  Post.h
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property (nonatomic, strong) NSNumber *sourceID;
@property (nonatomic, strong) NSNumber *postID;
@property (nonatomic, strong) NSNumber *unixDate;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSArray<NSDictionary *> *photoURLArray;
@property (nonatomic, strong) NSNumber *countOfLikes;
@property (nonatomic, strong) NSNumber *countOfReposts;
@property (nonatomic, strong) NSNumber *countOfComments;
@property (nonatomic, strong) NSNumber *countOfViews;

@property (nonatomic, copy) NSString *authorFirstName;
@property (nonatomic, copy) NSString *authorSecondName;
@property (nonatomic, copy) NSString *authorFotoURL;

@end

NS_ASSUME_NONNULL_END
