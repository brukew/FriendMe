//
//  NotificationsViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 8/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NotificationsViewControllerDelegate

- (void)didCheck;

@end

@interface NotificationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *likedBy;

@property (nonatomic, weak) id<NotificationsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
