//
//  TweetVC.m
//  twitter
//
//  Created by Henry Ching on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "ComposeTweetVC.h"
#import "TwitterClient.h"

@interface TweetVC ()

@property (weak, nonatomic) IBOutlet UILabel *currentTweet_name;
@property (weak, nonatomic) IBOutlet UILabel *currentTweet_username;
@property (weak, nonatomic) IBOutlet UIImageView *currentTweet_profileImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTweet_tweetText;
@property (weak, nonatomic) IBOutlet UILabel *currentTweet_tweetTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *currentTweet_retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *currentTweet_favoritesCount;

@property (weak) NSString *favoritedFlag;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)onComposeTweetButton;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;

@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Tweet";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeTweetButton)];
    
    self.currentTweet_name.text = self.currentTweet.name;
    NSData *profileImageData = [NSData dataWithContentsOfURL:self.currentTweet.profileImage];
    [self.currentTweet_profileImage setImage:[UIImage imageWithData:profileImageData]];
    self.currentTweet_tweetText.text = self.currentTweet.text;
    [self.currentTweet_tweetText sizeToFit];
    
    NSDateFormatter *displayFormat = [[NSDateFormatter alloc] init];
    [displayFormat setDateFormat:@"M/dd/yyy HH:mm"];
    NSString *dateString = [displayFormat stringFromDate:self.currentTweet.tweetTime];
    self.currentTweet_tweetTimestamp.text = [NSString stringWithFormat:@"%@", dateString];
    [self.currentTweet_tweetTimestamp sizeToFit];
    
    self.currentTweet_username.text = [NSString stringWithFormat:@"@%@", self.currentTweet.username];
    [self.currentTweet_username sizeToFit];
    self.currentTweet_retweetCount.text = [NSString stringWithFormat:@"%@ RETWEETS", self.currentTweet.retweetCount];
    self.currentTweet_favoritesCount.text = [NSString stringWithFormat:@"%@ FAVORITES", self.currentTweet.favoritesCount];
    self.favoritedFlag = self.currentTweet.favoritedFlag;
    
    if([self.currentTweet.favoritedFlag integerValue] == 0) {
        [self.favoriteButton setTitle:(@"favorite") forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setTitle:(@"favorited") forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    
    if([self.currentTweet.retweetedFlag integerValue] == 0) {
        [self.retweetButton setTitle:(@"retweet") forState:UIControlStateNormal];
        [self.retweetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setTitle:(@"retweeted") forState:UIControlStateNormal];
        [self.retweetButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onComposeTweetButton
{
    [self.navigationController presentViewController:[[ComposeTweetVC alloc] init] animated:YES completion:nil];
}

- (IBAction)onReplyButton:(id)sender {
    ComposeTweetVC *composeTweet = [[ComposeTweetVC alloc] init];
    composeTweet.currentTweet = self.currentTweet;
    [self.navigationController presentViewController:composeTweet animated:YES completion:nil];

}

- (IBAction)onRetweetButton:(id)sender {
    if([self.currentTweet.retweetedFlag integerValue] == 0) {
        [[TwitterClient instance] retweet:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            [sender setTitle:(@"retweeted") forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        NSLog(@"Already retweeted");
    }
}

- (IBAction)onFavoriteButton:(id)sender {
    if([self.currentTweet.favoritedFlag integerValue] == 0) {
        [[TwitterClient instance] favoriteTweet:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            [sender setTitle:(@"favorited") forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [[TwitterClient instance] unfavoriteTweet:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            [sender setTitle:(@"favorite") forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
