//
//  MatchCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import "MatchCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MatchCell

- (void) loadData{
    NSLog(@"%@", self.currentMatch.objectId);
    [PFObject fetchAll:[self.currentMatch objectForKey:@"firstName"]];
    NSLog(@"%@", [self.currentMatch objectForKey:@"firstName"]);

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
}

@end

