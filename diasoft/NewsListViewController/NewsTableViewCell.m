//
//  NewsTableViewCell.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//


#import "NewsTableViewCell.h"
#import "UIImage+Size.h"
#import "Post.h"
#import "NetworkService.h"


@implementation NewsTableViewCell

- (void)setupCellForPost:(Post *)post withNetworkService:(NetworkService *)networkService
{
    UIView *selectionBackgroundView = [UIView new];
    selectionBackgroundView.backgroundColor = [UIColor colorWithRed:204.f/255.f green:220.f/255.f blue:1 alpha:1];
    self.selectedBackgroundView = selectionBackgroundView;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", post.authorFirstName, post.authorSecondName];
    self.dateLabel.text = post.date;
    self.postTextLabel.text = post.text;
    self.likesLabel.text = post.countOfLikes.stringValue;
    self.commentsLabel.text = post.countOfComments.stringValue;
    self.repostsLabel.text = post.countOfComments.stringValue;
    
    self.avatarImageView.layer.cornerRadius = 25;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.image = [UIImage imageNamed:@"noPhoto"];
    [networkService downloadPhotoWithURL:post.authorFotoURL withComplitionBlock:^(id  _Nullable image) {
        self.avatarImageView.image = image;
    }];
    
    if ([post.photoURLArray count] > 0)
    {
        NSNumber *imageHeight = ((NSNumber *)post.photoURLArray[0][@"height"]);
        NSNumber *imageWidth = ((NSNumber *)post.photoURLArray[0][@"width"]);
        NSNumber *newImageWidth = @(self.contentView.frame.size.width - 10);
        NSNumber *scale = @(imageWidth.floatValue / newImageWidth.floatValue);
        NSNumber *newHeight = @(imageHeight.floatValue / scale.floatValue);
        
        self.postPhotoImageView.image = [UIImage imageWithImage:[UIImage imageNamed:@"noPhoto"] forSize:CGSizeMake(newImageWidth.floatValue, newHeight.floatValue)];
        [networkService downloadPhotoWithURL:post.photoURLArray[0][@"url"] withComplitionBlock:^(id  _Nullable image) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *sizedImage = [UIImage imageWithImage:image
                                                      forSize:CGSizeMake(newImageWidth.floatValue,
                                                                         newHeight.floatValue)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.postPhotoImageView.image = sizedImage;
                });
            });
        }];
    }
    else
    {
        self.postPhotoImageView.image = nil;
    }
}

- (void)showOnlyPreviewOfTextForMaxCountOfLetters:(NSUInteger)maxCountOfLetters
{
    NSString *text = self.postTextLabel.text;
    
    if ([text length] > maxCountOfLetters)
    {
        text = [text substringToIndex:maxCountOfLetters];
        text = [text stringByAppendingString:@"..."];
        self.postTextLabel.text = text;
    }
}

@end
