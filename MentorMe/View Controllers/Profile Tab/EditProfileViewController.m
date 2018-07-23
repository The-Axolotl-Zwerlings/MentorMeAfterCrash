//
//  EditProfileViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 7/20/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Parse/Parse.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyLabel;
@property (weak, nonatomic) IBOutlet UITextField *majorLabel;
@property (weak, nonatomic) IBOutlet UITextField *schoolLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser* user = [PFUser currentUser];
    self.nameLabel.placeholder = user[@"name"];
    self.jobTitleLabel.placeholder = user[@"jobTitle"];
    self.companyLabel.placeholder = user[@"company"];
    self.majorLabel.placeholder = user[@"major"];
    self.schoolLabel.placeholder = user[@"school"];
    self.biographyTextView.text = user[@"bio"];
    self.profilePictureImageView.file = user[@"profilePic"];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTapSave:(id)sender {
    
    PFUser* currUser = [PFUser currentUser];
    
    currUser.name = self.nameLabel.text;
    currUser.jobTitle = self.jobTitleLabel.text;
    currUser.company = self.companyLabel.text;
    currUser.major = self.majorLabel.text;
    currUser.school = self.schoolLabel.text;
    currUser.bio = self.biographyTextView.text;
    currUser.profilePic = self.profilePictureImageView.file;
    
    [currUser saveInBackground];
    
    [self.delegate didEditProfile];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapPhotoLibraryButton:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (IBAction)onTapCameraButton:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profilePictureImageView.file = nil;
    CGSize size = CGSizeMake(80, 80);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    PFFile *imageFile = [self getPFFileFromImage:resizedImage];
    
    [imageFile saveInBackground];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:@"profilePicture"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            self.profilePictureImageView.file = user.profilePic;
            [self.profilePictureImageView loadInBackground];
            
            NSLog( @"set new image" );
            
        }
    }];
    
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
    
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
