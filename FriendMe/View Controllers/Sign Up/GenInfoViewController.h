//
//  GenInfoViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *BirthdateTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

NS_ASSUME_NONNULL_END
