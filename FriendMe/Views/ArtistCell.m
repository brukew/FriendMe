//
//  ArtistCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/27/21.
//

#import "ArtistCell.h"
#import "UIImageView+AFNetworking.h"
@implementation ArtistCell

- (void) loadData{
    NSURL *imageURL= [NSURL URLWithString:self.URLString];
    [self.artistImage setImageWithURL:imageURL];
    self.artistName.text = self.name;
    
}
@end
