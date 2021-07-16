//
//  APIManager.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "APIManager.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

static NSString * const SpotifyClientID = @"cad3439e0ad84169a65d5ed857f5e936";
static NSString * const SpotifySecretID = @"88fa106db16141f182474f18216ca6c9";
static NSString * const SpotifyRedirectURLString = @"spotify-ios-quick-start://spotify-login-callback";


#pragma mark - Authorization example

#pragma mark - Actions

- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion{
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    
//    configuration.tokenSwapURL = [NSURL URLWithString:@"https://glitch.com/edit/#!/metal-bedecked-cave/api/token"];
//    configuration.tokenRefreshURL = [NSURL URLWithString:@"https://glitch.com/edit/#!/metal-bedecked-cave/api/refresh_token"];
    /*
     The session manager lets you authorize, get access tokens, and so on.
     */
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                    delegate:self];
    /*
     Scopes let you specify exactly what types of data your application wants to
     access, and the set of scopes you pass in your call determines what access
     permissions the user is asked to grant.
     For more information, see https://developer.spotify.com/web-api/using-scopes/.
     */
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;

    /*
     Start the authorization process. This requires user input.
     */
    if (@available(iOS 11, *)) {
        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"success: %@", session.description);
    self.token = session.refreshToken;
    [self getSpotifyTracksArtists:^(NSDictionary *dict, NSError *error) {
        if (error){
            NSLog(@"fail3: %@", error);
        }
    }];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session.description);
}

- (void) getBearerToken{}


#pragma mark - Pulling Spotify data

-(void) getBearerToken:(void (^)(NSDictionary *, NSError*))completion{
    
}

-(void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion{
    NSURL *url = [NSURL URLWithString:@"https://api.spotify.com/v1/me/top/artists"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [request addValue:[@"Basic " stringByAppendingString:self.token] forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"error: %@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"success: %@", dataDictionary);
               
           }
       }];
    //[self.refreshControl endRefreshing];
    [task resume];
}


@end
