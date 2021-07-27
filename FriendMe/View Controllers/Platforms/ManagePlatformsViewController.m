//
//  ManagePlatformsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/16/21.
//

#import "ManagePlatformsViewController.h"
#import <Parse/Parse.h>
#import "Platform.h"
#import "UIImageView+AFNetworking.h"
#import "PlatformChangeWeightCell.h"

@interface ManagePlatformsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ManagePlatformsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PFUser *current = [PFUser currentUser];
    NSMutableArray *platforms = current[@"platforms"];
    return platforms.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlatformChangeWeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatformChangeWeightCell" forIndexPath:indexPath];
    PFUser *current = [PFUser currentUser];
    NSString *platformID= current[@"platforms"][indexPath.row];
    PFQuery *query = [PFQuery queryWithClassName:@"Platform"];
    [query getObjectInBackgroundWithId:platformID block:^(PFObject *platform, NSError *error) {
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
