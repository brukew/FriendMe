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
#import "APIManager2.h"

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

- (IBAction)liked:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.heartPopup.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3);
                    self.heartPopup.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }];
        }];
    [self updateLikes];

}

- (void)updateLikes{
    PFUser *current = [PFUser currentUser];
    NSMutableArray *likes;
    if (current[@"likes"]){
        likes = current[@"likes"];
    }
    else{
        likes = [NSMutableArray new];
    }
    if ([likes containsObject:self.userID]){
        [likes removeObject:self.userID];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.heart.alpha = 0;
        }completion:^(BOOL finished) {
        }];
    }
    else{
        [likes addObject:self.userID];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.heart.alpha = 1;
        }completion:^(BOOL finished) {
        }];
    }
    NSLog(@"%@", likes);
    current[@"likes"] = likes;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
}

-(void) loadData{
    PFUser *current = [PFUser currentUser];
    [self setUpScroll];
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
    
    if ([current[@"likes"] containsObject:self.userID]){
        self.heart.alpha = 1;
    }
}

- (void) setUpScroll{
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
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liked:)];
            tapGestureRecognizer.numberOfTapsRequired = 2;
            [imageView setUserInteractionEnabled:YES];
            [imageView addGestureRecognizer:tapGestureRecognizer];
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
    [self.scrollView bringSubviewToFront:self.heartPopup];
    [self.scrollView bringSubviewToFront:self.heart];
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
