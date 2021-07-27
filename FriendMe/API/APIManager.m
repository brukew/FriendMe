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
#import <CoreData/CoreData.h>
#import "ConnectViewController.h"

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
    completion(nil, nil);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}



#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    self.token = session.accessToken;
    [self getSpotifyTracksArtists:^(NSDictionary *dict, NSError *error) {
        if (error){
            NSLog(@"fail3: %@", error);
        }
        else{
            [self saveData:dict];
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
    // get artists
    [self getSpotifyData:@"https://api.spotify.com/v1/me/top/artists" completion:^(NSDictionary * artistDict, NSError * error) {
        if (!error){
            NSArray *artistArray = artistDict[@"items"];
            // get dictionary of genres and artists based on top artists
            NSDictionary *artistDict = [self convertSpotifyArtists:artistArray];
            // get tracks data
            [self getSpotifyData:@"https://api.spotify.com/v1/me/top/tracks" completion:^(NSDictionary * tracksDict, NSError * error) {
                if (!error){
                    NSArray *tracksArray = tracksDict[@"items"];
                    // get dictionary of genres, tracks, and artists based on top tracks
                    NSDictionary *tracksDict =[self convertSpotifyTracks:tracksArray];
                    [artistDict[@"artists"] unionSet:tracksDict[@"artists"]];
                    completion(@{@"artists": artistDict[@"artists"], @"tracks":tracksDict[@"tracks"], @"albums": tracksDict[@"albums"], @"genres": artistDict[@"genres"], @"images": artistDict[@"images"]}, nil);
                }
                else{
                    NSLog(@"Error, Trouble getting tracks: %@", error.localizedDescription);
                }
            }];
        }
        else{
            NSLog(@"Error, Trouble getting artists: %@", error.localizedDescription);
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


- (NSDictionary *) convertSpotifyArtists:(NSArray *)artists{
    NSMutableSet *genreSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    NSMutableArray *artistImages = [NSMutableArray new];
    for (NSDictionary *artist in artists){
        [artistImages addObject:artist[@"images"][2][@"url"]];
        [genreSet addObjectsFromArray:artist[@"genres"]];
        [artistSet addObject:artist[@"id"]];
    }
    return @{@"genres": genreSet, @"artists": artistSet, @"images": artistImages};
}

- (NSDictionary *) convertSpotifyTracks:(NSArray *)tracks{
    NSMutableSet *trackSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    NSMutableSet *albumSet = [[NSMutableSet alloc] init];
    for (NSDictionary *track in tracks){
        NSDictionary *albumItems = track[@"album"];
        // adds album and artist of album to set
        [albumSet addObject:albumItems[@"id"]];
        for (NSDictionary *artist in albumItems[@"artists"]){
            [artistSet addObject:artist[@"id"]];
        }
        
        // adds artists on song to set
        NSArray *trackArtists = track[@"artists"];
        if (trackArtists.count>1){
            for (NSDictionary *artist in trackArtists){
                [artistSet addObject:artist[@"id"]];
            }
        }
        
        // adds track id to set
        [trackSet addObject:track[@"id"]];
    }
    return @{@"albums": albumSet, @"artists": artistSet, @"tracks":trackSet};
}
//
//-(void) saveData:(NSDictionary *) spotifyData{
//    PFUser *current = [PFUser currentUser];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *archivedData = [userDefaults objectForKey:current.objectId];
//    if (archivedData != nil){
//        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//        //if twitter data has already been saved, add that to new dict
//        if (dataDict[@"Twitter"]){
//            NSArray *twitterData = dataDict[@"Twitter"];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData, @"Twitter":twitterData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//        else{
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//    }
//    else {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData} requiringSecureCoding:YES error:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:data forKey:current.objectId];
//    }
//}

-(void) saveData:(NSDictionary *) spotifyData{
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", current.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    NSManagedObject *currentSpotify;
    NSManagedObject *userData;
    if (results.count){
        userData = results[0];
        currentSpotify = [userData valueForKey:@"spotifyData"];
    }
    else{
        userData = [NSEntityDescription insertNewObjectForEntityForName:@"RegUser" inManagedObjectContext:moc];
        [userData setValue:current.objectId forKey:@"id"];
        currentSpotify = NULL;
    }
    if (currentSpotify == NULL){
        currentSpotify = [NSEntityDescription insertNewObjectForEntityForName:@"Spotify" inManagedObjectContext:moc];
    }
    [currentSpotify setValue:spotifyData[@"genres"] forKey:@"genres"];
    [currentSpotify setValue:spotifyData[@"tracks"] forKey:@"tracks"];
    [currentSpotify setValue:spotifyData[@"artists"] forKey:@"artists"];
    [currentSpotify setValue:spotifyData[@"albums"] forKey:@"albums"];
    [currentSpotify setValue:spotifyData[@"images"] forKey:@"images"];
    [userData setValue:currentSpotify forKey:@"spotifyData"];
    if ([moc save:nil] == NO) {
        NSLog(@"Error saving context");
    }
    
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *archivedData = [userDefaults objectForKey:current.objectId];
//    if (archivedData != nil){
//        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//        //if twitter data has already been saved, add that to new dict
//        if (dataDict[@"Twitter"]){
//            NSArray *twitterData = dataDict[@"Twitter"];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData, @"Twitter":twitterData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//        else{
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//    }
//    else {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData} requiringSecureCoding:YES error:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:data forKey:current.objectId];
//    }
}
@end
