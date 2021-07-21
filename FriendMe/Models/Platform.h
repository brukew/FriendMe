//
//  Platform.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/13/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Platform : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nonnull name;
@property (nonatomic) NSNumber * _Nonnull weight;

+ (void) addPlatform: ( NSString * _Nullable )name withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) updateWeights: (NSNumber * _Nullable)weight ofPlatform: (Platform * _Nullable)platform withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (BOOL *) alreadyAdded: ( NSString * )name;

@end

NS_ASSUME_NONNULL_END
