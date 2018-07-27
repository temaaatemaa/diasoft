//
//  SinglePostViewController.h
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface SinglePostViewController : UIViewController

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
