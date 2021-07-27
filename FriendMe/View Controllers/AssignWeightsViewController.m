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
    // Do any additional setup after loading the view.
}

- (IBAction)saveWeights:(id)sender {
    PFUser *current = [PFUser currentUser];
    double twitterWeight = 0.0;
    double spotifyWeight = 0.0;
    NSMutableArray *weights = [NSMutableArray new];
    twitterWeight = self.twitterSlider.value;
//    [Platform updateWeights:@(roundf(cell.platformSlider.value*100)/100) ofPlatform:cell.platform withCompletion:nil];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
