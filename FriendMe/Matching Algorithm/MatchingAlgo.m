//
//  MatchingAlgo.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/21/21.
//

#import "MatchingAlgo.h"
#import <Parse/Parse.h>

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *currentArchivedData = [userDefaults objectForKey:current.objectId];
    NSDictionary *userData = [NSKeyedUnarchiver unarchiveObjectWithData:currentArchivedData];
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
        }
    }];
}

+ (double) compareSpotifyData:(PFObject *)potentialMatch withData:(NSDictionary *)userData{
    double spotifyMatch = 0.0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *matchArchivedData = [userDefaults objectForKey:potentialMatch.objectId];
    NSDictionary *matchData = [NSKeyedUnarchiver unarchiveObjectWithData:matchArchivedData];
    if (userData[@"Spotify"] && matchData[@"Spotify"]){
        NSMutableSet *genres = [NSMutableSet setWithSet:userData[@"Spotify"][@"genres"]];
        NSMutableSet *albums = [NSMutableSet setWithSet:userData[@"Spotify"][@"albums"]];
        NSMutableSet *tracks = [NSMutableSet setWithSet:userData[@"Spotify"][@"tracks"]];
        NSMutableSet *artists = [NSMutableSet setWithSet:userData[@"Spotify"][@"artists"]];
        NSInteger genreCount = [genres count];
        NSInteger albumCount = [albums count];
        NSInteger trackCount = [tracks count];
        NSInteger artistCount = [artists count];
        [genres intersectSet:matchData[@"Spotify"][@"genres"]];
        [tracks intersectSet:matchData[@"Spotify"][@"tracks"]];
        [albums intersectSet:matchData[@"Spotify"][@"albums"]];
        [artists intersectSet:matchData[@"Spotify"][@"artists"]];
        spotifyMatch = ((genres.count/genreCount)*0.2) + ((tracks.count/trackCount)*0.3) + ((albums.count/albumCount)*0.2) + ((artists.count/artistCount)*0.3);
    }
    return spotifyMatch;
}

+ (double) compareTwitterData:(PFObject *)potentialMatch withData:(NSDictionary *)userData{
    double twitterMatch = 0.0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *matchArchivedData = [userDefaults objectForKey:potentialMatch.objectId];
    NSDictionary *matchData = [NSKeyedUnarchiver unarchiveObjectWithData:matchArchivedData];
    if (userData[@"Twitter"] && matchData[@"Twitter"]){
        NSMutableSet *friends = [NSMutableSet setWithSet:userData[@"Twitter"]];
        NSInteger friendCount = [friends count];
        [friends intersectSet:matchData[@"Twitter"]];
        twitterMatch = friends.count/friendCount;
    }
    return twitterMatch;
}
//
+ (void) compare:(PFObject *)potentialMatch withDictionary:(NSMutableDictionary *)matches withData:(NSDictionary *)data {
    double spotifyComp = [self compareSpotifyData:potentialMatch withData:data];
    double twitterComp = [self compareTwitterData:potentialMatch withData:data];
    [matches setObject:[NSNumber numberWithDouble:spotifyComp + twitterComp] forKey:potentialMatch.objectId];
}
@end
