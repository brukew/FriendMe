//
//  ProfileViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"
#import "EditProfileViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ArtistCell.h"

@interface ProfileViewController () <UIScrollViewDelegate, EditProfileViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    self.scrollView.layer.cornerRadius = 8;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
            
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self.collectionView reloadData];
    
    self.editButton.layer.cornerRadius = 5;
    [self loadData];
    
}

-(void) loadData{
    PFUser *current = [PFUser currentUser];
    if (current[@"pictures"]){
        NSMutableArray *images = current[@"pictures"];
        NSInteger ix;
        for( ix = 0; ix < images.count; ix+=1 ) {
            CGRect frame;
            frame.origin.x = self.scrollView.frame.size.width * (CGFloat)ix;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
            
            UIImageView *imageView = [[PFImageView alloc] initWithFrame:frame];
            PFFileObject * profileImage = [images objectAtIndex:ix];
            NSURL * imageURL = [NSURL URLWithString:profileImage.url];
            [imageView setImageWithURL:imageURL];
            [self.scrollView addSubview:imageView];
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (CGFloat)images.count, self.scrollView.frame.size.height);
    }
    else{
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * (CGFloat)0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:@"image_placeholder.png"]];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (CGFloat)1, self.scrollView.frame.size.height);
    }
    
    self.scrollView.delegate = self;
    self.nameLabel.text = [[[current[@"firstName"] stringByAppendingString:@" "] stringByAppendingString:current[@"lastName"]] stringByAppendingString:@","];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:current[@"DOB"]
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    if (current[@"bio"]){
        self.bioLabel.text = current[@"bio"];
    }
    self.pageControl.numberOfPages = [current[@"pictures"] count];
    [self.scrollView bringSubviewToFront:self.pageControl];
    [self.scrollView bringSubviewToFront:self.editButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = (int)page;
}

- (void)didEdit{
    [self loadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", current.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    if (results){
        NSManagedObject *userData = results[0];
        NSManagedObject *spotify = [userData valueForKey:@"spotifyData"];
        NSArray *artistImages = [spotify valueForKey:@"images"];
        self.images = artistImages;
    }
    else{
        self.images = @[];
    }
    if (!self.images){
        self.spotLabel.alpha = 0;
        self.topArtistLabel.alpha = 0;
        self.collectionView.alpha = 0;
    }
    return self.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ArtistCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistCell" forIndexPath:indexPath];
    cell.URLString = self.images[indexPath.row][1];
    cell.name = self.images[indexPath.row][0];
    [cell loadData];
    return cell;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"editProfile"]){
        EditProfileViewController *editProfileController = [segue destinationViewController];
        editProfileController.delegate = self;
    }
}


@end
