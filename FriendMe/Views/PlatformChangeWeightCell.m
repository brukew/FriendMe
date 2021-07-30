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
    PFUser *current = [PFUser currentUser];
    if ([self.platform[@"name"] isEqual:@"Spotify"]){
        self.weightSlider.value = [current[@"weights"][0] floatValue];
    }
    if ([self.platform[@"name"] isEqual:@"Twitter"]){
        self.weightSlider.value = [current[@"weights"][1] floatValue];
    }
    [self.weightSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    PFUser *current = [PFUser currentUser];
    NSMutableArray *weights = [NSMutableArray arrayWithArray:current[@"weights"]];
    if ([self.platform[@"name"] isEqual:@"Spotify"]){
        weights[0] = @(self.weightSlider.value);
    }
    if ([self.platform[@"name"] isEqual:@"Twitter"]){
        weights[1] = @(self.weightSlider.value);
    }
    current[@"weights"] = weights;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}

@end
