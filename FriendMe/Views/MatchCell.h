//
//  MatchCell.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


NS_ASSUME_NONNULL_BEGIN

@interface MatchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UIImageView *heartNoFill;
@property (weak, nonatomic) IBOutlet UIImageView *spotifyImage;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;

@property (weak, nonatomic) PFObject *currentMatch;

-(void) loadData;

@end

NS_ASSUME_NONNULL_END
