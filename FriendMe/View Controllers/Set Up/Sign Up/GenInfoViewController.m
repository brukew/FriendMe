//
//  GenInfoViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "GenInfoViewController.h"
#import "Parse/Parse.h"

@interface GenInfoViewController () <UITextFieldDelegate>

@end

@implementation GenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BirthdateTextfield.delegate = self;
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];

    [datePicker setDate:[NSDate date]];

    NSDate *theMaximumDate = [NSDate date];
    [datePicker setMaximumDate:theMaximumDate];
    
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [datePicker setDatePickerMode:UIDatePickerModeDate];


    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];

    [self.BirthdateTextfield setInputView:datePicker];
    
    self.nextButton.layer.cornerRadius = 4;

}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.BirthdateTextfield.inputView;
    self.BirthdateTextfield.text = [self formatDate:picker.date];
}

- (IBAction)addInfo:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.BirthdateTextfield.inputView;
    PFUser *current = [PFUser currentUser];
    current[@"firstName"] = self.firstNameField.text;
    current[@"lastName"] = self.lastNameField.text;
    current[@"DOB"] = picker.date;
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
