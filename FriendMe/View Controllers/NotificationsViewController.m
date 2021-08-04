//
//  NotificationsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 8/3/21.
//

#import "NotificationsViewController.h"
#import "Matches/MatchesViewController.h"
#import "NotificationCell.h"
#import <Parse/Parse.h>

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation NotificationsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likedBy.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    NSString *userId = self.likedBy[indexPath.row];
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userId block:^(PFObject *user, NSError *error) {
        if (!error) {
            cell.user = user;
            [cell loadData];
        }
    }];
    return cell;
}

- (IBAction)dismissNotifications:(id)sender {
    [self.delegate didCheck];
    [self dismissViewControllerAnimated:true completion: nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
 

- (IBAction)notificationButton:(id)sender {
}
@end
