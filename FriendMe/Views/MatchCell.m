//
//  MatchCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import "MatchCell.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "UIColor+HTColor.h"


@implementation MatchCell

- (void) loadData{
    PFUser *current = [PFUser currentUser];
    
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0;
    self.layer.masksToBounds = NO;
    
    self.nameLabel.text = [[self.currentMatch[@"firstName"] stringByAppendingString:@" "] stringByAppendingString:self.currentMatch[@"lastName"]];
    self.nameLabel.textColor = [UIColor blackColor];
    if (self.currentMatch[@"pictures"]){
        PFFileObject * profileImage = [self.currentMatch[@"pictures"] objectAtIndex:0];
        NSURL * imageURL = [NSURL URLWithString:profileImage.url];
        [self.profilePicView setImageWithURL:imageURL];
    }
    else{
        [self.profilePicView setImage:[UIImage imageNamed:@"image_placeholder.png"]];
    }
    
    // configure likes
    self.heartNoFill.alpha = 0;
    self.heart.alpha = 0;
    if ([self.currentMatch[@"likes"] containsObject:current.objectId]){
        self.layer.shadowColor = [UIColor redColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 0.6f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
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
    
    //configure platform icons
    self.spotifyImage.alpha = 0;
    self.twitterImage.alpha = 0;
    NSArray *platforms = self.currentMatch[@"platforms"];
    if ([self.currentMatch[@"bothPlatforms"] isEqual:@1]){
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
