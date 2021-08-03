//
//  MatchesViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *likedByNew;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationButton;


@end

NS_ASSUME_NONNULL_END
