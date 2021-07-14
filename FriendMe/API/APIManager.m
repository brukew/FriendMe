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


@end
