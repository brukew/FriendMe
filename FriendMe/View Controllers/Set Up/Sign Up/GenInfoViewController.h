//
//  GenInfoViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>


NS_ASSUME_NONNULL_BEGIN

@interface GenInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *lastNameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *BirthdateTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

NS_ASSUME_NONNULL_END
