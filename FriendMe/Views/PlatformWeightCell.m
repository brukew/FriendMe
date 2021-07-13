//
//  PlatformWeightCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import "PlatformWeightCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PlatformWeightCell

//TODO: Custom Slider

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadData{
    self.platformTitle.text = self.platform[@"name"];
    NSString *imageName = [self.platform[@"name"] stringByAppendingString:@".png"];
    [self.platformImageView setImage:[UIImage imageNamed:imageName]];
    self.platformSlider.maximumValue = 1;
    self.platformSlider.minimumValue = 0;
}

@end
