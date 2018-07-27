//
//  ImageTableViewCell.h
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetworkService;
@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;

- (void)setupCellWithUrl:(NSString *)url forPost:(Post *)post withNetworkService:(NetworkService *)networkService;

@end

NS_ASSUME_NONNULL_END
