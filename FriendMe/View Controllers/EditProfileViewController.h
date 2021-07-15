//
//  EditProfileViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end

NS_ASSUME_NONNULL_END
