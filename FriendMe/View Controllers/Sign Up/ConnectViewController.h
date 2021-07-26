//
//  ConnectViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/22/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *twitterView;
@property (weak, nonatomic) IBOutlet UIView *spotifyView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterCheck;
@property (weak, nonatomic) IBOutlet UIImageView *spotifyCheck;

@end

NS_ASSUME_NONNULL_END
