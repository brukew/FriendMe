//
//  PlatformCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "PlatformCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PlatformCell

- (void) loadData{
    
    NSString *imageName = [self.platform stringByAppendingString:@".png"];
    [self.platformImageView setImage:[UIImage imageNamed:imageName]];
    
}

@end


