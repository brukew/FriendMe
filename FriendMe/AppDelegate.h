//
//  AppDelegate.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTSessionManagerDelegate>

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;

- (void) setUpSpotify;

@end

