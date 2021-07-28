//
//  BeginViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/15/21.
//

#import "BeginViewController.h"

@interface BeginViewController ()

@end

@implementation BeginViewController

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
    
    
    HTPressableButton *logInButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(120, 450, 150, 50) buttonStyle:HTPressableButtonStyleRounded];
    [logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    logInButton.buttonColor = [UIColor ht_blueJeansColor];
    logInButton.shadowColor = [UIColor ht_blueJeansDarkColor];
    [logInButton addTarget:self
                 action:@selector(logInSegue)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInButton];
    
    HTPressableButton *signUpButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(120, 560, 150, 50) buttonStyle:HTPressableButtonStyleRounded];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpButton.buttonColor = [UIColor ht_blueJeansColor];
    signUpButton.shadowColor = [UIColor ht_blueJeansDarkColor];
    [signUpButton addTarget:self
                 action:@selector(signUpSegue)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    
}

- (void) signUpSegue{
    [self performSegueWithIdentifier:@"toSignUp" sender:nil];
}

- (void) logInSegue{
    [self performSegueWithIdentifier:@"toLogIn" sender:nil];
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
