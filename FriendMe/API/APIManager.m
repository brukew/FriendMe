//
//  APIManager.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "APIManager.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "MatchesViewController.h"


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


#pragma mark - Actions

- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion{
    NSString *spotifyClientID = SpotifyClientID;
    NSURL *spotifyRedirectURL = [NSURL URLWithString:SpotifyRedirectURLString];

    self.configuration  = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
    
//    NSURL *tokenSwapURL = [NSURL URLWithString:@"https://[my token swap app domain]/api/token"];
//    NSURL *tokenRefreshURL = [NSURL URLWithString:@"https://[my token swap app domain]/api/refresh_token"];
//
//    self.configuration.tokenSwapURL = tokenSwapURL;
//    self.configuration.tokenRefreshURL = tokenRefreshURL;
    self.configuration.playURI = @"";

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
    
    SPTScope requestedScope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope |  SPTUserTopReadScope;
     
    if (@available(iOS 11, *)) {
        // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    } else {
        // Use this on iOS versions < 11 to use SFSafariViewController
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}



#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"success: %@", session.description);
    self.token = session.accessToken;
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



#pragma mark - Pulling Spotify data

-(void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion{
    [self getSpotifyData:@"https://api.spotify.com/v1/me/top/artists" completion:^(NSDictionary * artistDict, NSError * error) {
        if (!error){
            NSLog(@"success: artists");
            NSArray *artistArray = artistDict[@"items"];
            [self convertSpotifyArtists:artistArray];
        }
        else{
            NSLog(@"Error, Trouble getting artists: %@", error.localizedDescription);
        }
    }];
    [self getSpotifyData:@"https://api.spotify.com/v1/me/top/tracks" completion:^(NSDictionary * tracksDict, NSError * error) {
        if (!error){
            NSArray *tracksArray = tracksDict[@"items"];
            [self convertSpotifyTracks:tracksArray];
        }
        else{
            NSLog(@"Error, Trouble getting tracks: %@", error.localizedDescription);
        }
    }];
}


-(void) getSpotifyData:(NSString *)urlString completion:(void (^)(NSDictionary *, NSError*))completion{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"GET"];
    [request addValue:[@"Bearer " stringByAppendingString:self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"error: %@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}


- (void) convertSpotifyArtists:(NSArray *)artists{
    NSMutableSet *genreSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    for (NSDictionary *artist in artists){
        [genreSet addObjectsFromArray:artist[@"genres"]];
        [artistSet addObject:artist[@"id"]];
    }
    NSLog(@"%@", genreSet);
    NSLog(@"%@", artistSet);
}

- (void) convertSpotifyTracks:(NSArray *)tracks{
    NSMutableSet *trackSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    NSMutableSet *albumSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *track in tracks){
//        NS
//        for (NSDictionary *track in tracks)
//        [genreSet addObjects:artist[@"genres"]];
//        [artistSet addObject:artist[@"id"]];
//    }
//    NSLog(@"%@", genreSet);
//    NSLog(@"%@", artistSet);
}
@end
