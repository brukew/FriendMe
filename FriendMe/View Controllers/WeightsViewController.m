//
//  WeightsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import "WeightsViewController.h"
#import <Parse/Parse.h>
#import "PlatformWeightCell.h"
#import "Platform.h"
#import "MatchingAlgo.h"


@interface WeightsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

//TODO: Adjust tbale view height + constraints based on number of platforms

@implementation WeightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (IBAction)saveData:(id)sender {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger section = 0; section < [self.tableView numberOfSections]; ++section)
    {
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:section]; ++row)
        {
            [cells addObject:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]]];
        }
    }
    PFUser *current = [PFUser currentUser];
    double twitterWeight = 0.0;
    double spotifyWeight = 0.0;
    NSMutableArray *weights = [NSMutableArray new];
    for (PlatformWeightCell *cell in cells)
    {
        NSLog(@"%@", cell);
        if ([cell.platform[@"name"] isEqual:@"Twitter"]){
            twitterWeight =cell.platformSlider.value;
        }
        if ([cell.platform[@"name"] isEqual:@"Spotify"]){
            spotifyWeight =cell.platformSlider.value;
        }
        [Platform updateWeights:@(roundf(cell.platformSlider.value*100)/100) ofPlatform:cell.platform withCompletion:nil];
    }
    [weights addObject:@(twitterWeight)];
    [weights insertObject:@(spotifyWeight) atIndex:0];
    current[@"weights"] = weights;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            [MatchingAlgo lookForMatches];
        }
    }];
    [self performSegueWithIdentifier:@"weightsToPicsSegue" sender:nil];
    // segue
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PFUser *current = [PFUser currentUser];
    NSArray *platformArray = current[@"platforms"];
    return platformArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatformWeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatformWeightCell" forIndexPath:indexPath];
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Platform"];
    [query getObjectInBackgroundWithId:current[@"platforms"][indexPath.row] block:^(PFObject *platform, NSError *error) {
        if (!error) {
            cell.platform = platform;
            [cell loadData];
        } else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    return cell;
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
