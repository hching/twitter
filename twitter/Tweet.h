//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, assign, readonly) NSString *tweetId;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSDate *tweetTime;
@property (nonatomic, strong, readonly) NSURL *profileImage;
@property (nonatomic, strong, readonly) NSString *favoritesCount;
@property (nonatomic, strong, readonly) NSString *retweetCount;
@property (nonatomic, strong, readonly) NSString *retweetedFlag;
@property (nonatomic, strong, readonly) NSString *favoritedFlag;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
