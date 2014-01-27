//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)tweetId {
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

- (NSString *)name {
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)username {
    return [self.data valueOrNilForKeyPath:@"user.screen_name"];
}

- (NSString *)profileImage {
    return [NSURL URLWithString:[self.data valueOrNilForKeyPath:@"user.profile_image_url"]];
}

- (NSDate *)tweetTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
    NSDate *date = [dateFormat dateFromString:[self.data valueOrNilForKeyPath:@"created_at"]];
    return date;
}

- (NSString *)favoritesCount {
    return [self.data valueOrNilForKeyPath:@"favorite_count"];
}

- (NSString *)retweetCount {
    return [self.data valueOrNilForKeyPath:@"retweet_count"];
}

- (NSString *)retweetedFlag{
    return [self.data valueOrNilForKeyPath:@"retweeted"];
}

- (NSString *)favoritedFlag {
    return [self.data valueOrNilForKeyPath:@"favorited"];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
