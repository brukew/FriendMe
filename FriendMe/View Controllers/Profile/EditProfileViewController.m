//
//  EditProfileViewController.m
//  FriendMe
//
//  Created by Bruke Wossenseged on 7/14/21.
//

#import "EditProfileViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "GMImagePickerController.h"

@interface EditProfileViewController () <UITextViewDelegate, GMImagePickerControllerDelegate>

@property (strong, nonatomic) GMImagePickerController *picker;
@property (strong, nonatomic) NSArray *assets;

@end

@implementation EditProfileViewController

BOOL changed;


- (void)viewDidLoad {
    [super viewDidLoad];
    changed = NO;
    self.picker = [[GMImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.displaySelectionInfoToolbar = YES;

    self.picker.displayAlbumsNumberOfAssets = YES;

    self.picker.customNavigationBarPrompt = @"Choose photos to be featured on your profile!";
    self.picker.title = @"FriendMe";

    self.picker.colsInPortrait = 3;
    self.picker.colsInLandscape = 5;
    self.picker.minimumInteritemSpacing = 2.0;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.picsView setUserInteractionEnabled:YES];
    [self.picsView  addGestureRecognizer:tapGestureRecognizer];
    
    self.bioTextView.delegate = self;
    
    PFUser *current = [PFUser currentUser];
    self.firstNameField.text = current[@"firstName"];
    self.lastNameField.text = current[@"lastName"];
    if (current[@"bio"]){
        self.bioTextView.text = current[@"bio"];
    }
    else {
        self.bioTextView.text = @"Tell everyone more about yourself!";
        self.bioTextView.textColor = [UIColor lightGrayColor];
    }
    self.picsView.layer.cornerRadius = 5;
    if (current[@"pictures"]){
        PFFileObject * profileImage = current[@"pictures"][0];
        NSURL * imageURL = [NSURL URLWithString:profileImage.url];
        [self.picsView setImageWithURL:imageURL];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.bioTextView.textColor == [UIColor lightGrayColor]) {
        self.bioTextView.text = nil;
        self.bioTextView.textColor = [UIColor blackColor];
        }
    changed = YES;
}


#pragma ImagePicker

- (IBAction)photoTapped:(UITapGestureRecognizer *)sender {
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    self.assets = assetArray;
    [self.picker dismissViewControllerAnimated:true completion:nil];
}

-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    [self.picker dismissViewControllerAnimated:true completion:nil];
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

#pragma Wrap Up
- (IBAction)doneEditing:(id)sender {
    PFUser *current = PFUser.currentUser;
    current[@"firstName"] = self.firstNameField.text;
    current[@"lastName"] = self.lastNameField.text;
    if (changed){
        current[@"bio"] = self.bioTextView.text;
    }
    if (self.assets){
        current[@"pictures"] = [self convertImages: self.assets];
    }
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            [self.delegate didEdit];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

@end
