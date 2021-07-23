//
//  MatchingAlgo.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/21/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END

@interface MatchingAlgo : NSObject

+ (instancetype)shared;

+ (void) lookForMatches;
+ (void) compare:(PFObject *)potentialMatch withDictionary:(NSMutableDictionary *)matches withData:(NSManagedObject *)data;
+ (double) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify;
+ (double) compareTwitterData:(PFObject *)potentialMatch withData:(NSManagedObject *)userTwitter;

@end
