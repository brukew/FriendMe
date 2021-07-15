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

@interface MatchesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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
    NSMutableArray *matches = current[@"matches"];
    //TODO: Implement matching algo?
    return matches.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MatchCell" forIndexPath:indexPath];
    PFUser *current = [PFUser currentUser];
    cell.currentMatch = current[@"matches"][indexPath.item];
    [cell loadData];
    return cell;
    
}

- (IBAction)testAddMatches:(id)sender {
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    NSArray *users = [query findObjects];
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    for (PFUser *user in users){
        if (user!=current){
            [matches addObject:user];
        }
    }
    NSLog(@"Users %@", matches);
    current[@"matches"] = matches;
    [self.collectionView reloadData];
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
