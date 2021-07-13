//
//  WeightsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import "WeightsViewController.h"
#import "Parse/Parse.h"
#import "PlatformWeightCell.h"

@interface WeightsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

//TODO: Adjust tbale view height + constraints based on number of platforms
//TODO: Addd weights functionality

@implementation WeightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (IBAction)saveData:(id)sender {
    
    //run through table view cells and collect data
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
