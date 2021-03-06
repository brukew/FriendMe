//
//  TwitterAPIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import <CoreData/CoreData.h>

@interface TwitterAPIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getFollowersWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;


@end
