//
//  MatchProfileViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/19/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MatchProfileViewControllerDelegate

- (void)didLeave;

@end

@interface MatchProfileViewController : UIViewController

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) PFObject *user;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartPopup;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UILabel *spotLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArtistLabel;

@property (nonatomic, weak) id<MatchProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
