//
//  VKAutharisation.h
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VKAutharisation;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const KeyForToken;
extern NSString *const KeyForUserID;

@protocol VKAutharisationDelegate


- (void)autharisationDidDone:(VKAutharisation *)vkAutharisation
                   withToken:(NSString *)token;

- (void)autharisationDidCancel:(VKAutharisation *)vkAutharisation;


@end


@interface VKAutharisation : NSObject


+ (NSString * _Nullable )token;
/*
    Если пользователь не авторизован то возвращается NULL.
 */

- (void)autharisation;
/*
    По выполнении вызывается один из методов делегата.
 */


- (void)logout;

@property (nonatomic, weak) id <VKAutharisationDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
