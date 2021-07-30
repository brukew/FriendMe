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
#import "UIColor+HTColor.h"

@interface ManagePlatformsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ManagePlatformsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *topColor = [UIColor ht_blueJeansDarkColor];
    UIColor *bottomColor = [UIColor whiteColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;

    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        }
    }];
    return cell;
}

@end
