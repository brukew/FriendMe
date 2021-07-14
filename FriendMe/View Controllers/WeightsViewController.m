//
//  WeightsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import "WeightsViewController.h"
#import "Parse/Parse.h"
#import "PlatformWeightCell.h"
#import "Platform.h"
#import <math.h>

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
    NSArray *platformArray = current[@"platforms"]; //make sure platforms are saved!
    NSLog(@"%@", platformArray);
    for (PlatformWeightCell *cell in cells)
    {

        [Platform updateWeights:@(roundf(cell.platformSlider.value*100)/100) ofPlatform:cell.platform withCompletion:nil];
    }
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
    cell.platform = current[@"platforms"][indexPath.row];
    [cell loadData];
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
