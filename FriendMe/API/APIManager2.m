//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager2.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager2()

@end

@implementation APIManager2

+ (instancetype)shared {
    static APIManager2 *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // TODO: fix code below to pull API Keys from your new Keys.plist file
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSString *key= [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    // Check for launch arguments override
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
           // Success
        NSArray *ids = dataDictionary[@"ids"];
        [self saveData:[NSSet setWithArray:ids]];
        completion(ids, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           NSLog(@"Error: %@", error.localizedDescription);
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
    if ([moc save:nil] == NO) {
        NSLog(@"Error saving context");
    }
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *archivedData = [userDefaults objectForKey:current.objectId];
//    if (archivedData != nil){
//        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//        //if twitter data has already been saved, add that to new dict
//        if (dataDict[@"Spotify"]){
//            NSArray *spotifyData = dataDict[@"Spotify"];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Spotify": spotifyData, @"Twitter":twitterData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//        else{
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Twitter":twitterData} requiringSecureCoding:YES error:nil];
//            [userDefaults setObject:data forKey:current.objectId];
//        }
//    }
//    else {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"Twitter":twitterData} requiringSecureCoding:YES error:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:data forKey:current.objectId];
//    }
}


@end
