//
//  PhotosViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "PhotosViewController.h"
#import "GMImagePickerController.h"
#import <Photos/Photos.h>
#import <Parse/Parse.h>

@interface PhotosViewController () <GMImagePickerControllerDelegate>

@property (strong, nonatomic) GMImagePickerController *picker;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[GMImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.displaySelectionInfoToolbar = YES;

    self.picker.displayAlbumsNumberOfAssets = YES;

    self.picker.customNavigationBarPrompt = @"Choose photos to be featured on your profile!";
    self.picker.title = @"FriendMe";

    self.picker.colsInPortrait = 3;
    self.picker.colsInLandscape = 5;
    self.picker.minimumInteritemSpacing = 2.0;

}

- (IBAction)chooseImages:(id)sender {
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    PFUser *current = [PFUser currentUser];
    current[@"pictures"] = [self convertImages: assetArray];
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    [self performSegueWithIdentifier:@"toTabBar" sender:nil];
}

-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    [self performSegueWithIdentifier:@"toTabBar" sender:nil];
}

-(NSMutableArray*) convertImages:(NSArray *)assets{
    PHImageManager *manager = [PHImageManager defaultManager];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    requestOptions.synchronous = YES;
    
    for (int i = 0; i < [assets count]; i++) {

        [manager requestImageForAsset:[assets objectAtIndex:i]
                           targetSize:CGSizeMake(390, 407)
                          contentMode:PHImageContentModeAspectFill
                              options:requestOptions
                        resultHandler:^(UIImage *image, NSDictionary *info){
                            NSData *imageData = UIImagePNGRepresentation(image);
                            PFFileObject *fileObj = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
                            [images addObject:fileObj];
                        }];
    }
    return images;
}
/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/
@end
