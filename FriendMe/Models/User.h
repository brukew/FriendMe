//
//  User.h
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/12/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject

@property (nonatomic, strong) NSString * _Nonnull objectID;
@property (nonatomic, strong) NSString * _Nonnull userID;
@property (nonatomic, strong) PFUser * _Nonnull author;

@property (nonatomic, strong) NSString * _Nonnull caption;
@property (nonatomic, strong) PFFileObject * _Nullable image;
@property (nonatomic, strong) NSNumber * _Nullable likeCount;
@property (nonatomic, strong) NSNumber * _Nullable commentCount;

@end

NS_ASSUME_NONNULL_END
