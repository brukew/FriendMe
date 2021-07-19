//
//  ManagePlatformsViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/16/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagePlatformsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *platformImageView;
@property (weak, nonatomic) IBOutlet UISlider *weightSlider;

@end

NS_ASSUME_NONNULL_END
