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


@interface ProfileViewController () <UIScrollViewDelegate, EditProfileViewControllerDelegate>

@end

@implementation ProfileViewController

//TODO: Clean up page
//TODO: Add api data

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
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
    self.nameLabel.text = [[current[@"firstName"] stringByAppendingString:@" "] stringByAppendingString:current[@"lastName"]];
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = (int)page;
}

- (void)didEdit{
    [self loadData];
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
