//
//  PlatformChangeWeightCell.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/19/21.
//

#import "PlatformChangeWeightCell.h"

@implementation PlatformChangeWeightCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) loadData{
    self.titleLabel.text = self.platform[@"name"];
    NSString *imageName = [self.platform[@"name"] stringByAppendingString:@".png"];
    [self.platformImageView setImage:[UIImage imageNamed:imageName]];
    self.weightSlider.maximumValue = 1;
    self.weightSlider.minimumValue = 0;
    self.weightSlider.value = [self.platform[@"weight"] floatValue];
}

@end
