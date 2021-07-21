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
    [newPlatform saveInBackgroundWithBlock:^(BOOL succeded, NSError * _Nullable error){
        if (succeded){
            if (!current[@"platforms"]){
                current[@"platforms"] = [NSMutableArray arrayWithObject:newPlatform.objectId];
            }
            else{
                [current[@"platforms"] addObject:newPlatform.objectId];
            }
            [current saveInBackgroundWithBlock: completion];
        }
        
    }];
}

+ (void) updateWeights: (NSNumber * _Nullable)weight ofPlatform: (Platform * _Nullable)platform withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    platform.weight = weight;
    [platform saveInBackgroundWithBlock: completion];
}

+ (BOOL *) alreadyAdded: ( NSString * )name{
    //FIX FIX FIX
    PFUser *current = [PFUser currentUser];
    __block BOOL *added = FALSE;
    for (NSString *platformID in current[@"platforms"]){
        PFQuery *query = [PFQuery queryWithClassName:@"Platform"];
        [query getObjectInBackgroundWithId:platformID block:^(PFObject *platform, NSError *error) {
            if (!error) {
                if ([platform[@"name"] isEqual:name]){
                    added = TRUE;
                };
            } else {
                NSLog(@"Fail %@", error.localizedDescription);
            }
        }];
    }
    return added;
}

@end
