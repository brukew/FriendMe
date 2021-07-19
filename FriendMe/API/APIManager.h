//
//  APIManager.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END

@interface APIManager : NSObject <SPTSessionManagerDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) NSString *token;

- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion;

- (void) setUpSpotifyWithCompletion2:(void (^)(NSDictionary *, NSError*))completion;

@end
