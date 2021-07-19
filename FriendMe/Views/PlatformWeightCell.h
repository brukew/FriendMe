//
//  PlatformWeightCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Platform.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlatformWeightCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *platformTitle;
@property (strong, nonatomic) IBOutlet UIImageView *platformImageView;
@property (strong, nonatomic) IBOutlet UISlider *platformSlider;
@property (weak, nonatomic) PFObject *platform;

- (void) loadData;

@end

NS_ASSUME_NONNULL_END
