//
//  GenInfoViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "GenInfoViewController.h"
#import "Parse/Parse.h"
#import "UIColor+HTColor.h"


@interface GenInfoViewController () <UITextFieldDelegate>

@end

@implementation GenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *topColor = [UIColor ht_blueJeansDarkColor];
    UIColor *bottomColor = [UIColor whiteColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;

    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.birthdateTextField.delegate = self;
    
    [self.firstNameField setPlaceholder:@"First Name" floatingTitle:@"First"];
    self.firstNameField.floatingLabelYPadding = -15;
    [self.lastNameField setPlaceholder:@"Last Name" floatingTitle:@"Last"];
    self.lastNameField.floatingLabelYPadding = -15;
    [self.birthdateTextField setPlaceholder:@"Date of Birth" floatingTitle:@"DOB"];
    self.birthdateTextField.floatingLabelYPadding = -15;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];

    [datePicker setDate:[NSDate date]];

    NSDate *theMaximumDate = [NSDate date];
    [datePicker setMaximumDate:theMaximumDate];
    
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [datePicker setDatePickerMode:UIDatePickerModeDate];


    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];

    [self.birthdateTextField setInputView:datePicker];
    
    self.nextButton.layer.cornerRadius = 4;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:TRUE];
    return false;
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.birthdateTextField.inputView;
    self.birthdateTextField.text = [self formatDate:picker.date];
}

- (IBAction)addInfo:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.birthdateTextField.inputView;
    PFUser *current = [PFUser currentUser];
    current[@"firstName"] = self.firstNameField.text;
    current[@"lastName"] = self.lastNameField.text;
    current[@"DOB"] = picker.date;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}

@end
