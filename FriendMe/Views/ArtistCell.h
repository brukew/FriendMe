//
//  ArtistCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtistCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;

@property (weak, nonatomic) NSString *URLString;

-(void) loadData;

@end

NS_ASSUME_NONNULL_END