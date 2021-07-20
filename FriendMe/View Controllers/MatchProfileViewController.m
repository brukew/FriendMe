//
//  MatchProfileViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/19/21.
//

#import "MatchProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"

@interface MatchProfileViewController () <UIScrollViewDelegate>

@end

@implementation MatchProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    PFQuery *query = [PFUser query];
    
    [query getObjectInBackgroundWithId:self.userID block:^(PFObject *user, NSError *error) {
        if (!error) {
            self.user = user;
            [self loadData];
        }
        else {
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    
}

-(void) loadData{
    if (self.user[@"pictures"]){
        NSMutableArray *images = self.user[@"pictures"];
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
    self.nameLabel.text = [[self.user[@"firstName"] stringByAppendingString:@" "] stringByAppendingString:self.user[@"lastName"]];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:self.user[@"DOB"]
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    if (self.user[@"bio"]){
        self.bioLabel.text = self.user[@"bio"];
    }
    self.pageControl.numberOfPages = [self.user[@"pictures"] count];
    [self.scrollView bringSubviewToFront:self.pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = (int)page;
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
