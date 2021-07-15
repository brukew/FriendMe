//
//  EditProfileViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import <UIKit/UIKit.h>

@protocol  EditProfileViewControllerDelegate

- (void)didEdit;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIImageView *picsView;

@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
