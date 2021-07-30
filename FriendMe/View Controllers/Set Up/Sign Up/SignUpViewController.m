//
//  SignUpViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "UIColor+HTColor.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the colors
    UIColor *topColor = [UIColor ht_blueJeansDarkColor];
    UIColor *bottomColor = [UIColor whiteColor];
        
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;

    //Add gradient to view
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    
    self.signUpButton.layer.cornerRadius = 4;
    
    [self.usernameField setPlaceholder:@"Username" floatingTitle:@"Username"];
    self.usernameField.floatingLabelYPadding = -15;
    [self.passwordField setPlaceholder:@"Password" floatingTitle:@"Password"];
    self.passwordField.floatingLabelYPadding = -15;
    [self.emailField setPlaceholder:@"Email" floatingTitle:@"Email"];
    self.emailField.floatingLabelYPadding = -15;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:TRUE];
    return false;
}

- (IBAction)registerUser:(id)sender {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Sign Up"
                                                                           message:@"Try Again."
                                                                           preferredStyle:(UIAlertControllerStyleAlert)];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            PFUser *current = [PFUser currentUser];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
            NSManagedObject *userData = [NSEntityDescription insertNewObjectForEntityForName:@"RegUser" inManagedObjectContext:moc];
            [userData setValue:current.objectId forKey:@"id"];
            [moc save:nil];
            [self performSegueWithIdentifier:@"signUpToInfoSegue" sender:nil];
        }
    }];
}

@end
