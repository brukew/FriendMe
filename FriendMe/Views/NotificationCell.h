//
//  NotificationCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 8/3/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;
@property (strong, nonatomic) PFObject *user;

- (void) loadData;
@end

NS_ASSUME_NONNULL_END
