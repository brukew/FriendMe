//
//  TwitterAPIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TwitterAPIManager.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface TwitterAPIManager()

@end

@implementation TwitterAPIManager

+ (instancetype)shared {
    static TwitterAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
        
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *key= [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getFollowersWithCompletion:(void(^)(NSMutableArray *tweets, NSError *error))completion {
    NSDictionary *parameters = @{@"stringify_ids":@"true"};

    [self GET:@"1.1/friends/ids.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * dataDictionary) {
        NSArray *ids = dataDictionary[@"ids"];
        [self saveData:[NSSet setWithArray:ids]];
        completion(ids, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           completion(nil, error);
    }];
}

-(void) saveData:(NSSet *) twitterData{
    PFUser *current = [PFUser currentUser];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [[delegate persistentContainer] viewContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RegUser"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", current.objectId]];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    NSManagedObject *currentTwitter;
    NSManagedObject *userData;
    if (results.count){
        userData = results[0];
        currentTwitter = [userData valueForKey:@"twitterData"];
    }
    else{
        userData = [NSEntityDescription insertNewObjectForEntityForName:@"RegUser" inManagedObjectContext:moc];
        [userData setValue:current.objectId forKey:@"id"];
        currentTwitter = NULL;
    }
    if (currentTwitter == NULL){
        currentTwitter = [NSEntityDescription insertNewObjectForEntityForName:@"Twitter" inManagedObjectContext:moc];
    }
    [currentTwitter setValue:twitterData forKey:@"friends"];
    [userData setValue:currentTwitter forKey:@"twitterData"];
    NSLog(@"%@", [userData valueForKey:@"twitterData"]);
    [moc save:nil];
}


@end

