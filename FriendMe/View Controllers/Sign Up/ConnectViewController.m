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

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spotifyConnect:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.spotifyImage setUserInteractionEnabled:YES];
    [self.spotifyImage  addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twitterConnect:)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [self.twitterImage setUserInteractionEnabled:YES];
    [self.twitterImage  addGestureRecognizer:tapGestureRecognizer];
    
    // Do any additional setup after loading the view.
}
- (IBAction)spotifyConnect:(UITapGestureRecognizer *)sender {
    APIManager *api = [APIManager shared];
    
    [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSLog(@"Success");
            //add green check mark under label
        }
    }];
}
- (IBAction)twitterConnect:(UITapGestureRecognizer *)sender {
    [[APIManager2 shared] loginWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            [[APIManager2 shared] getFollowersWithCompletion:^(NSMutableArray *data, NSError *error){
            }];
            NSLog(@"Success");
            //add green check mark under label and add transparent grey overlay on image view
            
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
