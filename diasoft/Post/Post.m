//
//  Post.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "Post.h"

@implementation Post


#pragma mark - Custom Accessors

- (NSString *)authorSecondName
{
    if (!_authorSecondName)
    {
        return @"";
    }
    return _authorSecondName;
}

- (NSString *)text
{
    if (!_text)
    {
        return @"";
    }
    return _text;
}

- (NSString *)date
{
    if (!_unixDate)
    {
        return @"";
    }
    
    return [self getNormalDateFromUnix:_unixDate];
}

#pragma mark - Private Methods

- (NSString *)getNormalDateFromUnix:(NSNumber *)unixDate
{
    double timestampval =  unixDate.doubleValue;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
    [df_local setDateFormat:@"HH:mm:ss dd.MM.yyyy"];
    
    NSString *ts_local_string = [df_local stringFromDate:updatetimestamp];
    
    return [NSString stringWithFormat:@"%@",ts_local_string];
}

#pragma mark - Override NSObject methods

- (BOOL)isEqual:(id)object
{
    if ([((Post *)object).postID isEqualToNumber:self.postID])
    {
        return YES;
    }
    
    return NO;
}

-(NSUInteger)hash
{
    return 123455;
}

- (NSString *)description
{
    if (!_text)
    {
        _text = @"";
    }
    return [NSString stringWithFormat:@"<%@: %p, \"%@ %@\" postid: %@  sourseID:%@ text:%@ date:%@ likes:%@",
            [self class],
            self,
            _authorFirstName,
            _authorSecondName,
            _postID,
            _sourceID,
            _text,
            _unixDate,
            _countOfLikes
            ];
}
@end
