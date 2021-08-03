//
//  MatchesViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import "MatchesViewController.h"
#import "SceneDelegate.h"
#import "BeginViewController.h"
#import <Parse/Parse.h>
#import "MatchCell.h"
#import "SpotifyAPIManager.h"
#import "MatchProfileViewController.h"
#import "TwitterAPIManager.h"
#import "MatchingAlgo.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "NotificationsViewController.h"

@interface MatchesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MatchProfileViewControllerDelegate, NotificationsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *matches;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *topColor = [UIColor ht_blueJeansDarkColor];
    UIColor *bottomColor = [UIColor whiteColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    self.notificationButton.tintColor = [UIColor grayColor];

    [self.view.layer insertSublayer:theViewGradient atIndex:0];
            
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    self.collectionView.alwaysBounceVertical = YES;
    
    CGFloat postsPerRow = 2.1;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [MatchingAlgo lookForMatches];
    [self.collectionView reloadData];
}


- (IBAction)onLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BeginViewController *beginViewController = [storyboard instantiateViewControllerWithIdentifier:@"BeginViewController"];
    //need to use keyWindow
    [[UIApplication sharedApplication].keyWindow setRootViewController: beginViewController];
    
    [[TwitterAPIManager shared] logout];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self refresh];
    [refreshControl endRefreshing];
}

-(void)refresh{
    [MatchingAlgo lookForMatches];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PFUser *current = [PFUser currentUser];
    self.matches = current[@"matches"];
    return self.matches.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    self.likedByNew = [NSMutableArray new];
    [query getObjectInBackgroundWithId:current[@"matches"][indexPath.row] block:^(PFObject *match, NSError *error) {
        if (!error) {
            cell.currentMatch = match;
            if ([match[@"likes"] containsObject:current.objectId]){
                if (![current[@"likedBy"] containsObject: match.objectId]){
                    [self.likedByNew addObject:match.objectId];
                    
                    self.notificationButton.tintColor = [UIColor redColor];
                }
            }
            
            [cell loadData];
        }
    }];
    return cell;
    
}

- (void)didLeave{
    [self.collectionView reloadData];
}

- (void)didCheck{
    PFUser *current = [PFUser currentUser];
    [self.likedByNew addObjectsFromArray:current[@"likedBy"]];
    current[@"likedBy"] = self.likedByNew;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"toProfile"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        MatchProfileViewController *matchProfileController = [segue destinationViewController];
        PFUser *current = [PFUser currentUser];
        matchProfileController.userID = current[@"matches"][indexPath.item];
        matchProfileController.delegate = self;
    }
    if ([segue.identifier isEqual:@"toNoti"]){
        if (self.notificationButton.tintColor == [UIColor redColor]){
            NSLog(@"hello");
            NotificationsViewController *notificationsViewController = [segue destinationViewController];
            self.notificationButton.tintColor = [UIColor grayColor];
            notificationsViewController.likedBy = self.likedByNew;
            notificationsViewController.delegate = self;
        }
    }
}

@end
