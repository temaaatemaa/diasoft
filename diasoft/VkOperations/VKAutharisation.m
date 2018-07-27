//
//  VKAutharisation.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "VKAutharisation.h"
#import <SafariServices/SafariServices.h>

static NSString *const APP_ID = @"6642532";
static NSString *const AuthVKURL = @"https://oauth.vk.com/authorize";
static NSString *const RedirectVKURL = @"vk6642532://authorize";

NSString *const KeyForToken = @"KeyForToken";


@interface VKAutharisation()

@property (nonatomic, strong) SFAuthenticationSession *sessionSF;

@end


@implementation VKAutharisation

- (void)autharisation
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&v=5.80&revoke=1&scope=8194",
                           AuthVKURL,
                           APP_ID,
                           RedirectVKURL];
    NSURL *url = [NSURL URLWithString:urlString];

    void (^comlitionBlock)(NSURL * _Nullable, NSError * _Nullable) = ^(NSURL * _Nullable callbackURL, NSError * _Nullable error){
        NSString *string = [callbackURL absoluteString];
        
        if (!string)
        {
            [self.delegate autharisationDidCancel:self];
        }
        else
        {
            NSString *accessToken = [string substringFromIndex:35];
            accessToken = [accessToken substringToIndex:120-35];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:accessToken forKey:KeyForToken];
            
            [self.delegate autharisationDidDone:self withToken:accessToken];
        }
    };
    

    self.sessionSF = [[SFAuthenticationSession alloc]initWithURL:url callbackURLScheme:RedirectVKURL completionHandler:comlitionBlock];
    [self.sessionSF start];
}

+ (NSString *)token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:KeyForToken];
}

- (void)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:KeyForToken];
}

@end
