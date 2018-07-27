//
//  NewsTableViewCell.h
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;
@class NetworkService;

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postPhotoImageView;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repostsLabel;


- (void)setupCellForPost:(Post *)post withNetworkService:(NetworkService *)networkService;
- (void)showOnlyPreviewOfText;

@end

NS_ASSUME_NONNULL_END
