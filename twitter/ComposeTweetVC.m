//
//  ComposeTweetVC.m
//  twitter
//
//  Created by Henry Ching on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeTweetVC.h"

@interface ComposeTweetVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

- (IBAction)onTweetButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;

@end

@implementation ComposeTweetVC

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
    
    [self.tweetText becomeFirstResponder];
    
    User *me = [User currentUser];
    self.nameLabel.text = me.getCurrentUserName;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", me.getCurrentUserScreenName];
    
    NSData *profileImageData = [NSData dataWithContentsOfURL:me.getCurrentUserProfileImage];
    [self.profileImage setImage:[UIImage imageWithData:profileImageData]];
    
    if(self.currentTweet != nil) {
        self.tweetText.text = [[@"@" stringByAppendingString:self.currentTweet.username] stringByAppendingString:@" "];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTweetButton:(id)sender {
    if(self.currentTweet == nil) {
        [[TwitterClient instance] createTweet:self.tweetText.text success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } else {
        [[TwitterClient instance] replyTweet:self.tweetText.text  tweetId:self.currentTweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (IBAction)onCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
