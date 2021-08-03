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

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@end

@implementation NotificationsViewController

BOOL isTrackingPanLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    isTrackingPanLocation = FALSE;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    panGestureRecognizer.delegate = self;
    [self.tableView setUserInteractionEnabled:YES];
    [self.tableView addGestureRecognizer:panGestureRecognizer];
}

- (IBAction)panRecognized:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan && self.tableView.contentOffset.y == 0) {
        [recognizer setTranslation:CGPointZero inView:self.tableView];
        isTrackingPanLocation = true;
        }
    else if (recognizer.state != UIGestureRecognizerStateEnded && recognizer.state != UIGestureRecognizerStateCancelled &&
             recognizer.state != UIGestureRecognizerStateFailed && isTrackingPanLocation) {
        CGPoint panOffset = [recognizer translationInView:self.tableView];
        

        // determine offset of the pan from the start here.
        // When offset is far enough from table view top edge -
        // dismiss your view controller. Additionally you can
        // determine if pan goes in the wrong direction and
        // then reset flag isTrackingPanLocation to false

        BOOL eligiblePanOffset = panOffset.y > 200;
        if (eligiblePanOffset) {
            recognizer.enabled = false;
            recognizer.enabled = true;
            [self dismissViewControllerAnimated:true completion: nil];
        }

        if (panOffset.y < 0) {
            isTrackingPanLocation = false;
        }
    }
    else {
        isTrackingPanLocation = false;
    }
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
