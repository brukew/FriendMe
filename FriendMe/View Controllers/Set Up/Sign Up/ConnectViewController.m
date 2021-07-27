//
//  ConnectViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/22/21.
//

#import "ConnectViewController.h"
#import "SpotifyAPIManager.h"
#import "TwitterAPIManager.h"
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
        if (platforms){
            PFQuery *query = [PFQuery queryWithClassName:@"Platform"];
            [query getObjectInBackgroundWithId:platforms[0] block:^(PFObject *platform, NSError *error) {
                if (!error) {
                    if ([platform[@"name"] isEqual:@"Spotify"]){
                        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                        [array addObject:[NSNumber numberWithDouble:1.00]];
                        [array addObject:[NSNumber numberWithDouble:0.00]];
                        current[@"weights"] = array;
                    }
                    else{
                        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                        [array addObject:[NSNumber numberWithDouble:0.00]];
                        [array addObject:[NSNumber numberWithDouble:1.00]];
                        current[@"weights"] = array;
                    }
                }        }];
        }
        [self performSegueWithIdentifier:@"toWeightsSegue" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toPicsSegue" sender:nil];
    }
}

- (IBAction)spotifyConnect:(UITapGestureRecognizer *)sender {
    SpotifyAPIManager *api = [SpotifyAPIManager shared];
    
    [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            self.spotifyCheck.alpha = 1;
            [Platform addPlatform: @"Spotify" withCompletion: nil];
            [self.spotifyView removeGestureRecognizer:[self.spotifyView gestureRecognizers][0]];
        }
    }];
}
- (IBAction)twitterConnect:(UITapGestureRecognizer *)sender {
    [[TwitterAPIManager shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (!error) {
            [[TwitterAPIManager shared] getFollowersWithCompletion:^(NSMutableArray *data, NSError *error){
            }];
            self.twitterCheck.alpha = 1;
            [Platform addPlatform: @"Twitter" withCompletion: nil];
            [self.twitterView removeGestureRecognizer:[self.twitterView gestureRecognizers][0]];
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

@end
