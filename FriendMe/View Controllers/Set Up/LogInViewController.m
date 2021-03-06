
//
//  LogInViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "UIColor+HTColor.h"

@interface LogInViewController () <UITextFieldDelegate>

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *topColor = [UIColor ht_blueJeansDarkColor];
    UIColor *bottomColor = [UIColor whiteColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;

    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    self.logInButton.layer.cornerRadius = 4;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:TRUE];
    return false;
}
- (IBAction)logIn:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                                       message:@"Username and password required."
                                                                       preferredStyle:(UIAlertControllerStyleAlert)];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
        
        
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error == nil) {

            [self performSegueWithIdentifier:@"LogInSegue" sender:nil];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                                           message:@"Username and/or password incorrect."
                                                                           preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
    }];
}


@end
