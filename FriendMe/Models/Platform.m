//
//  Platform.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import "Platform.h"
#import "Parse/Parse.h"

@implementation Platform

@dynamic name;
@dynamic weight;


+ (nonnull NSString *)parseClassName {
return @"Platform";
}

+ (void) addPlatform: ( NSString * _Nullable )name withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Platform *newPlatform = [Platform new];
    newPlatform.name = name;
    PFUser *current = [PFUser currentUser];
    if (!current[@"platforms"]){
        current[@"platforms"] = [NSMutableArray arrayWithObject:newPlatform];
    }
    else{
        [current[@"platforms"] addObject:newPlatform];
    }
    [newPlatform saveInBackgroundWithBlock: completion];
    [current saveInBackgroundWithBlock: completion];
}

+ (void) updateWeights: (NSNumber * _Nullable)weight ofPlatform: (Platform * _Nullable)platform withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    platform.weight = weight;
    [platform saveInBackgroundWithBlock: completion];
}

@end
