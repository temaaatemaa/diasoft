//
//  ImageTableViewCell.m
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIImage+Size.h"
#import "NetworkService.h"
#import "Post.h"

@implementation ImageTableViewCell

- (void)setupCellWithUrl:(NSString *)url forPost:(Post *)post withNetworkService:(NetworkService *)networkService
{

    NSNumber *imageHeight = ((NSNumber *)post.photoURLArray[0][@"height"]);
    NSNumber *imageWidth = ((NSNumber *)post.photoURLArray[0][@"width"]);
    NSNumber *newImageWidth = @(self.contentView.frame.size.width - 10);
    NSNumber *scale = @(imageWidth.floatValue / newImageWidth.floatValue);
    NSNumber *newHeight = @(imageHeight.floatValue / scale.floatValue);
    self.postImage.image = [UIImage imageWithImage:[UIImage imageNamed:@"noPhoto"] forSize:CGSizeMake(newImageWidth.floatValue, newHeight.floatValue)];
    
    [networkService downloadPhotoWithURL:url withComplitionBlock:^(id  _Nullable image) {
        
        self.postImage.image = [UIImage imageWithImage:image forSize:CGSizeMake(newImageWidth.floatValue, newHeight.floatValue)];
        
    }];
}
@end
