//
//  PlatformsViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "PlatformsViewController.h"
#import "PlatformCell.h"

@interface PlatformsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation PlatformsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.arrayOfPlatforms = [NSArray arrayWithObjects: @"Spotify", @"Twitter", @"Instagram", @"Facebook", @"Youtube", @"Reddit", @"Steam", @"Doordash", @"Netflix", nil];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayOfPlatforms.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformCell" forIndexPath:indexPath];
    
    cell.platform = self.arrayOfPlatforms[indexPath.item];
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
