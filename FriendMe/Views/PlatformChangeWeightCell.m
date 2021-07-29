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
    NSMutableArray *weights = [NSMutableArray new];
    PFUser *current = [PFUser currentUser];
//    NSLog(@"%@", current[@"weights"]);
    if ([self.platform[@"name"] isEqual:@"Spotify"]){
        [weights addObject:@(self.weightSlider.value)];
        [weights addObject:current[@"weights"][1]];
    }
    if ([self.platform[@"name"] isEqual:@"Twitter"]){
        [weights addObject:current[@"weights"][0]];
        [weights addObject:@(self.weightSlider.value)];
    }
    current[@"weights"] = weights;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}

@end
