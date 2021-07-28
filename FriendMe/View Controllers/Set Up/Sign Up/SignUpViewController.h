//
//  SignUpViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *usernameField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *signUpButton;

@end

NS_ASSUME_NONNULL_END
