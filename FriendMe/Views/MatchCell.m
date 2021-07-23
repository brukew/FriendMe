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
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:self.currentMatch[@"DOB"]
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    @try
        {
            PFFileObject * profileImage = [self.currentMatch[@"pictures"] objectAtIndex:0];
            NSURL * imageURL = [NSURL URLWithString:profileImage.url];
            [self.profilePicView setImageWithURL:imageURL];
        }
        @catch(id anException) {
            [self.profilePicView setImage:[UIImage imageNamed:@"image_placeholder.png"]];
        }
    if ([self.currentMatch[@"likes"] containsObject:current.objectId]){
        [self bringSubviewToFront:self.heart];
        self.heart.alpha = 1;
    }
}

@end

