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

- (void)setupCellWithFotoInfo:(NSDictionary *)fotoInformation forPost:(Post *)post withNetworkService:(NetworkService *)networkService;
{
    NSNumber *imageHeight = ((NSNumber *)fotoInformation[@"height"]);
    NSNumber *imageWidth = ((NSNumber *)fotoInformation[@"width"]);
    NSNumber *newImageWidth = @(self.contentView.frame.size.width);
    NSNumber *scale = @(imageWidth.floatValue / newImageWidth.floatValue);
    NSNumber *newHeight = @(imageHeight.floatValue / scale.floatValue);
    
    __block CGSize newSize = CGSizeMake(newImageWidth.floatValue,newHeight.floatValue);
    UIImage *defaultImage = [UIImage imageNamed:@"noPhoto"];
    
    self.postImage.image = [UIImage imageWithImage:defaultImage forSize:newSize];
    
    [networkService downloadPhotoWithURL:fotoInformation[@"url"] withComplitionBlock:^(id  _Nullable image) {
        
        [UIImage resizeImage:image forSize:newSize OnGlobalQueueWithCmplitionOnMainThread:^(id  _Nullable image) {
            self.postImage.image = image;
        }];
        
    }];
}
@end
