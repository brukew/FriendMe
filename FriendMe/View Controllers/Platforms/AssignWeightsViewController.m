//
//  AssignWeightsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/26/21.
//

#import "AssignWeightsViewController.h"
#import <Parse/Parse.h>
#import "MatchingAlgo.h"

@interface AssignWeightsViewController ()

@end

@implementation AssignWeightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveWeights:(id)sender {
    PFUser *current = [PFUser currentUser];
    double twitterWeight = 0.0;
    double spotifyWeight = 0.0;
    NSMutableArray *weights = [NSMutableArray new];
    twitterWeight = self.twitterSlider.value;
    spotifyWeight = self.spotifySlider.value;
    [weights addObject:@(twitterWeight)];
    [weights insertObject:@(spotifyWeight) atIndex:0];
    current[@"weights"] = weights;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            [MatchingAlgo lookForMatches];
        }
    }];

    [self performSegueWithIdentifier:@"weightsToPicsSegue" sender:nil];
}


@end
