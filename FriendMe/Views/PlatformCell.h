//
//  PlatformCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *platformImageView;
@property (strong, nonatomic) NSString *platform;

- (void) loadData;

@end

NS_ASSUME_NONNULL_END
