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
#import "APIManager.h"
#import "MatchProfileViewController.h"
#import "APIManager2.h"
#import "MatchingAlgo.h"

@interface MatchesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *matches;

@end

@implementation MatchesViewController

//TODO: Fix autolayout + do actual matches

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 2;
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
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PFUser *current = [PFUser currentUser];
    //TODO: Implement matching algo?
    self.matches = current[@"matches"];
    return self.matches.count; //matches.count
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    NSLog(@"%@", current[@"matches"][indexPath.row]);
    [query getObjectInBackgroundWithId:current[@"matches"][indexPath.row] block:^(PFObject *match, NSError *error) {
        if (!error) {
            cell.currentMatch = match;
            [cell loadData];
        } else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    return cell;
    
}

- (IBAction)testAddMatches:(id)sender {
//    PFUser *current = [PFUser currentUser];
//    PFQuery *query = [PFUser query];
//    NSArray *users = [query findObjects];
//    self.matches = [[NSMutableArray alloc] init];
//    for (PFUser *user in users){
//        if (user!=current){
//            [self.matches addObject:user.objectId];
//        }
//    }
//    current[@"matches"] = self.matches;
//    [self.collectionView reloadData];
//    APIManager *api = [APIManager shared];
//
//    [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
//        if (error) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        else{
//            NSLog(@"Success: %@", data);
//        }
//    }];
    [[APIManager2 shared] getFollowersWithCompletion:^(NSMutableArray *datadictionary, NSError *error){
        if (!error){
            //save data
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"toProfile"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        MatchProfileViewController *matchProfileController = [segue destinationViewController];
        PFUser *current = [PFUser currentUser];
//        PFQuery *query = [PFUser query];
//        [query getObjectInBackgroundWithId:current[@"matches"][indexPath.item] block:^(PFObject *user, NSError *error) {
//            if (!error) {
//                matchProfileController.user = user;
//            }
//            else {
//                NSLog(@"Error %@", error.localizedDescription);
//            }
//        }];
        matchProfileController.userID = current[@"matches"][indexPath.item];
    }
}

@end
