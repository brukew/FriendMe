//
//  AppDelegate.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
      configuration.applicationId = @"IlFP2JM2k6TJ62Z5nzUPncJJ0j6felzJFmdbcA7y";
      configuration.clientKey = @"Cu5L71VgTial710iX8us2dV5F3tp0EZ9tUMymPre";
      configuration.server = @"https://parseapi.back4app.com/";
    }];
    [Parse initializeWithConfiguration:configuration];

    return YES;
}

- (void) setUpSpotify{
    
    NSString *spotifyClientID = @"cad3439e0ad84169a65d5ed857f5e936";
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"spotify-ios-quick-start://spotify-login-callback"];

    self.configuration  = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];

    NSURL *tokenSwapURL = [NSURL URLWithString:@"https://glitch.com/edit/#!/metal-bedecked-cave/api/token"];
    NSURL *tokenRefreshURL = [NSURL URLWithString:@"https://glitch.com/edit/#!/metal-bedecked-cave/api/refresh_token"];

    self.configuration.tokenSwapURL = tokenSwapURL;
    self.configuration.tokenRefreshURL = tokenRefreshURL;
    self.configuration.playURI = @"";

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
    
    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];

}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"success: %@", session);
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}



@end
