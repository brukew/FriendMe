//
//  NotificationCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 8/3/21.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) loadData{
    self.notiLabel.text = [@"Liked by @" stringByAppendingString:self.user[@"username"]];
}


@end
