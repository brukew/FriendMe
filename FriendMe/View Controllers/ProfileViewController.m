//
//  ProfileViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UIScrollViewDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    NSArray *images = [NSArray arrayWithObjects:@"image1",@"image2",@"image3", nil];
    NSInteger ix;
    
    for( ix = 0; ix < images.count; ix+=1 ) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * (CGFloat)ix;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        //NSString *imageName = [self.platform stringByAppendingString:@".png"];
        [imageView setImage:[UIImage imageNamed:@"Twitter.png"]];
        [self.scrollView insertSubview:imageView atIndex:0];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (CGFloat)images.count, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
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
