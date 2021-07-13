//
//  GenInfoViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "GenInfoViewController.h"
#import "Parse/Parse.h"

@interface GenInfoViewController ()

@end

@implementation GenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    self.datePicker.maximumDate = [NSDate date];
    // add in 18 + functionality
    
}

- (IBAction)addInfo:(id)sender {
    PFUser *current = [PFUser currentUser];
    current[@"firstName"] = self.firstNameField.text;
    current[@"lastName"] = self.lastNameField.text;
    current[@"DOB"] = self.datePicker.date;
    // add in 18 + functionality
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
