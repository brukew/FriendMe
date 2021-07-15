
//
//  LogInViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
