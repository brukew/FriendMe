//
//  PlatformsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "PlatformsViewController.h"
#import "PlatformCell.h"
#import "Parse/Parse.h"
#import "Platform.h"
#import "AppDelegate.h"

@interface PlatformsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation PlatformsViewController

static NSArray *arrayOfPlatforms;

//TODO: add platforms to user[@"platforms"] array after authentication after clicking cell
//TODO: make sure user can only click each platform once


- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    arrayOfPlatforms = [NSArray arrayWithObjects: @"Spotify", @"Twitter", @"Instagram", @"Facebook", @"Youtube", @"Reddit", @"Steam", @"Doordash", @"Netflix", nil];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self.collectionView reloadData];
}

- (IBAction)continueTapped:(id)sender {
    PFUser *current = [PFUser currentUser];
    if (current[@"platforms"]){
        [self performSegueWithIdentifier:@"toWeightsSegue" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toPicsSegue" sender:nil];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrayOfPlatforms.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformCell" forIndexPath:indexPath];
    
    cell.platform = arrayOfPlatforms[indexPath.item];
    [cell loadData];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([arrayOfPlatforms[indexPath.item]  isEqual: @"Spotify"]){
        AppDelegate *api = [AppDelegate shared];
        
        [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                NSLog(@"Success");
            }
        }];

    }
    [Platform addPlatform: arrayOfPlatforms[indexPath.item] withCompletion: nil];
    
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
