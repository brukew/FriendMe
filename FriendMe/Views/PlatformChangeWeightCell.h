//
//  PlatformChangeWeightCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/19/21.
//

#import <UIKit/UIKit.h>
#import "Platform.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlatformChangeWeightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *platformImageView;
@property (weak, nonatomic) IBOutlet UISlider *weightSlider;

@property (strong, nonatomic) PFObject *platform;

- (void) loadData;

@end

NS_ASSUME_NONNULL_END
