//
//  PhotosViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "PhotosViewController.h"
#import "GMImagePickerController.h"
#import <Photos/Photos.h>

@interface PhotosViewController () <GMImagePickerControllerDelegate>

@property (strong, nonatomic) GMImagePickerController *picker;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[GMImagePickerController alloc] init];
    self.picker.delegate = self;
    //Display or not the selection info Toolbar:
    self.picker.displaySelectionInfoToolbar = YES;

    //Display or not the number of assets in each album:
    self.picker.displayAlbumsNumberOfAssets = YES;

    //Customize the picker title and prompt (helper message over the title)
    self.picker.title = @"Custom title";
    self.picker.customNavigationBarPrompt = @"Custom helper message!";

    //Customize the number of cols depending on orientation and the inter-item spacing
    self.picker.colsInPortrait = 3;
    self.picker.colsInLandscape = 5;
    self.picker.minimumInteritemSpacing = 2.0;

}
- (void)viewDidAppear:(BOOL)animated{
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
}

-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"GMImagePicker: User pressed cancel button");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
