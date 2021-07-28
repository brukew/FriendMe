//
//  BeginViewController.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeginViewController : UIViewController
@property (weak, nonatomic) IBOutlet HTPressableButton *loginButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *signUpButton;

@end

NS_ASSUME_NONNULL_END
