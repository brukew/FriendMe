//
//  MatchingAlgo.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/21/21.
//

#import "MatchingAlgo.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation MatchingAlgo

+ (instancetype)shared {
    static MatchingAlgo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void) lookForMatches{
    NSMutableDictionary *matchDict = [NSMutableDictionary new];
    PFQuery *query = [PFUser query];
    NSArray *users = [query findObjects];
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", current.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    NSManagedObject *userData = results[0];
    for (PFObject *user in users){
        if (![user.objectId isEqual:[PFUser currentUser].objectId]){
            [MatchingAlgo compare:user withDictionary:matchDict withData:userData];
        }
    }
    NSArray *matches = [[[matchDict keysSortedByValueUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    current[@"matches"] = matches;
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            NSLog(@"matches: %@", current[@"matches"]);
            NSLog(@"matchDict: %@", matchDict);
        }
    }];
}

+ (double) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify{
    double spotifyMatch = 0.0;
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", potentialMatch.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    if (results.count){
        NSManagedObject *matchData = results[0];
        NSManagedObject *matchSpotify = [matchData valueForKey:@"spotifyData"];
        if (matchSpotify != NULL){
            NSMutableSet *genres = [NSMutableSet setWithSet:[userSpotify valueForKey:@"genres"]];
            NSMutableSet *tracks = [NSMutableSet setWithSet:[userSpotify valueForKey:@"tracks"]];
            NSMutableSet *albums = [NSMutableSet setWithSet:[userSpotify valueForKey:@"albums"]];
            NSMutableSet *artists = [NSMutableSet setWithSet:[userSpotify valueForKey:@"artists"]];
            NSInteger genreCount = [genres count];
            NSInteger albumCount = [albums count];
            NSInteger trackCount = [tracks count];
            NSInteger artistCount = [artists count];
            [genres intersectSet:[matchSpotify valueForKey:@"genres"]];
            [tracks intersectSet:[matchSpotify valueForKey:@"tracks"]];
            [albums intersectSet:[matchSpotify valueForKey:@"albums"]];
            [artists intersectSet:[matchSpotify valueForKey:@"artists"]];
            double newGenreCount = [genres count];
            double newAlbumCount = [albums count];
            double newTrackCount = [tracks count];
            double newArtistCount = [artists count];
            double weight = [current[@"weights"][0] doubleValue];
            spotifyMatch = (((newGenreCount/genreCount)*0.2) + ((newTrackCount/trackCount)*0.3) + ((newAlbumCount/albumCount)*0.2) + ((newArtistCount/artistCount)*0.3)) * weight;
        }
    }
//    PFUser *current = [PFUser currentUser];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *matchArchivedData = [userDefaults objectForKey:potentialMatch.objectId];
//    NSDictionary *matchData = [NSKeyedUnarchiver unarchiveObjectWithData:matchArchivedData];
//    if (userData[@"Spotify"] && matchData[@"Spotify"]){
//        NSMutableSet *genres = [NSMutableSet setWithSet:userData[@"Spotify"][@"genres"]];
//        NSMutableSet *albums = [NSMutableSet setWithSet:userData[@"Spotify"][@"albums"]];
//        NSMutableSet *tracks = [NSMutableSet setWithSet:userData[@"Spotify"][@"tracks"]];
//        NSMutableSet *artists = [NSMutableSet setWithSet:userData[@"Spotify"][@"artists"]];
//        NSInteger genreCount = [genres count];
//        NSInteger albumCount = [albums count];
//        NSInteger trackCount = [tracks count];
//        NSInteger artistCount = [artists count];
//        [genres intersectSet:matchData[@"Spotify"][@"genres"]];
//        [tracks intersectSet:matchData[@"Spotify"][@"tracks"]];
//        [albums intersectSet:matchData[@"Spotify"][@"albums"]];
//        [artists intersectSet:matchData[@"Spotify"][@"artists"]];
//        double newGenreCount = [genres count];
//        double newAlbumCount = [albums count];
//        double newTrackCount = [tracks count];
//        double newArtistCount = [artists count];
//        double weight = [current[@"weights"][0] doubleValue];
//        spotifyMatch = (((newGenreCount/genreCount)*0.2) + ((newTrackCount/trackCount)*0.3) + ((newAlbumCount/albumCount)*0.2) + ((newArtistCount/artistCount)*0.3)) * weight;
//    }
    return spotifyMatch;
}

+ (double) compareTwitterData:(PFObject *)potentialMatch withData:(NSManagedObject *)userTwitter{
    double twitterMatch = 0.0;
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", potentialMatch.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    if (results.count){
        NSManagedObject *matchData = results[0];
        NSManagedObject *matchTwitter = [matchData valueForKey:@"twitterData"];
        if (matchTwitter != NULL){
            NSMutableSet *friends = [NSMutableSet setWithSet:[userTwitter valueForKey:@"friends"]];
            NSInteger friendCount = [friends count];
            [friends intersectSet:[matchTwitter valueForKey:@"friends"]];
            double weight = [current[@"weights"][1] doubleValue];
            double newCount = [friends count];
            twitterMatch = ((newCount)/friendCount) * weight;
        }
    }
    
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *matchArchivedData = [userDefaults objectForKey:potentialMatch.objectId];
//    NSDictionary *matchData = [NSKeyedUnarchiver unarchiveObjectWithData:matchArchivedData];
//    if (userData[@"Twitter"] && matchData[@"Twitter"]){
//        NSMutableSet *friends = [NSMutableSet setWithSet:userData[@"Twitter"]];
//        NSInteger friendCount = [friends count];
//        [friends intersectSet:matchData[@"Twitter"]];
//        double weight = [current[@"weights"][1] doubleValue];
//        double newCount = [friends count];
//        twitterMatch = ((newCount)/friendCount) * weight;
//    }
    return twitterMatch;
}
//
+ (void) compare:(PFObject *)potentialMatch withDictionary:(NSMutableDictionary *)matches withData:(NSManagedObject *)data {
    NSManagedObject *twitter = [data valueForKey:@"twitterData"];
    NSManagedObject *spotify = [data valueForKey:@"spotifyData"];
    double spotifyComp = 0.0;
    double twitterComp = 0.0;
    if (spotify != NULL){
        spotifyComp = [self compareSpotifyData:potentialMatch withData:spotify];
    }
    if (twitter != NULL){
        twitterComp = [self compareTwitterData:potentialMatch withData:twitter];
    }
    [matches setObject:[NSNumber numberWithDouble:spotifyComp + twitterComp] forKey:potentialMatch.objectId];
}
@end
