//
//  MatchCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import "MatchCell.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@implementation MatchCell

- (void) loadData{
    PFUser *current = [PFUser currentUser];
    self.nameLabel.text = [[self.currentMatch[@"firstName"] stringByAppendingString:@" "] stringByAppendingString:self.currentMatch[@"lastName"]];
    if (self.currentMatch[@"pictures"]){
        PFFileObject * profileImage = [self.currentMatch[@"pictures"] objectAtIndex:0];
        NSURL * imageURL = [NSURL URLWithString:profileImage.url];
        [self.profilePicView setImageWithURL:imageURL];
    }
    else{
        [self.profilePicView setImage:[UIImage imageNamed:@"image_placeholder.png"]];
    }
    self.heartNoFill.alpha = 0;
    self.heart.alpha = 0;
    if ([self.currentMatch[@"likes"] containsObject:current.objectId]){
        if([current[@"likes"] containsObject:self.currentMatch.objectId]){
            [self bringSubviewToFront:self.heart];
            self.heart.alpha = 1;
            self.heartNoFill.alpha = 0;
        }
        else{
            [self bringSubviewToFront:self.heartNoFill];
            self.heart.alpha = 0;
            self.heartNoFill.alpha = 1;
        }
    }
    
    
    NSArray *platforms = self.currentMatch[@"platforms"];
    if ([current[@"bothPlatforms"] isEqual:@1]){
        self.spotifyImage.alpha = 1;
        self.twitterImage.alpha = 1;
    }
    else{
        NSString *platformId = platforms[0];
        PFQuery *query = [PFQuery queryWithClassName:@"Platform"];
        [query getObjectInBackgroundWithId:platformId block:^(PFObject *platform, NSError *error) {
            if (!error) {
                if ([platform[@"name"] isEqual:@"Spotify"]){
                    self.spotifyImage.alpha = 1;
                }
                else{
                    self.twitterImage.alpha = 1;
                }
            }        }];
    }
}

@end
