//
//  ConnectViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/22/21.
//

#import "ConnectViewController.h"
#import "APIManager.h"
#import "APIManager2.h"
#import <Parse/Parse.h>
#import "Platform.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)continueTapped:(id)sender {
    PFUser *current = [PFUser currentUser];
    NSArray *platforms = current[@"platforms"];
    if (platforms.count > 1){
        [self performSegueWithIdentifier:@"toWeightsSegue" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toPicsSegue" sender:nil];
    }
}

- (IBAction)spotifyConnect:(UITapGestureRecognizer *)sender {
    APIManager *api = [APIManager shared];
    
    [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            self.spotifyCheck.alpha = 1;
            [Platform addPlatform: @"Spotify" withCompletion: nil];
        }
    }];
}
- (IBAction)twitterConnect:(UITapGestureRecognizer *)sender {
    [[APIManager2 shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (!error) {
            [[APIManager2 shared] getFollowersWithCompletion:^(NSMutableArray *data, NSError *error){
            }];
//            UIView *newView = [[UIView alloc] initWithFrame:self.twitterView.frame];
//            newView.backgroundColor = [UIColor lightGrayColor];
//            newView.alpha = 0.5;
//            [self.view addSubview:newView];
//            [self.twitterView bringSubviewToFront:self.twitterCheck];
            self.twitterCheck.alpha = 1;
            [Platform addPlatform: @"Twitter" withCompletion: nil];
        }
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButton:(id)sender {
}
@end
