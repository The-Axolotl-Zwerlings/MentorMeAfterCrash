//
//  SignUpViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "DiscoverTableViewController.h"
#import "AutocompleteTableViewCell.h"
#import "InterestModel.h"


@interface SignUpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;
@property (weak, nonatomic) IBOutlet UITextField *JobTitleField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *institutionField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;

@property (weak, nonatomic) IBOutlet UIButton *addProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) UIImage* chosenProfilePicture;
@property (nonatomic, strong) UIImage* resizedProfilePicture;
@property (nonatomic, strong) NSArray* getAdviceInterests;
@property (nonatomic, strong) NSArray* giveAdviceInterests;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.getAdviceInterests = [[NSArray alloc]init];
    self.giveAdviceInterests = [[NSArray alloc]init];

    self.title = @"Enter Information";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(segue)];
  
    //Setting Table View Delegate & Data Source
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];

}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
}

-(void)segue{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)onTapAddToGet:(id)sender {
//
//    NSMutableArray *getAdviceMutable = [NSMutableArray arrayWithArray:self.getAdviceInterests];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"InterestModel"];
//    [query whereKey:@"subject" equalTo:self.getAdviceField.text];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", objects.count);
//            // Do something with the found objects
//            [getAdviceMutable addObject:objects[0]];
//            self.getAdviceField.text = nil;
//            self.addGetAdviceInterestButton.enabled = NO;
//            self.getAdviceInterests = [NSArray arrayWithArray:getAdviceMutable];
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    //    [self.getAdviceInterests addObject:self.getAdviceField.text];
    //    self.getAdviceField.text = nil;
    //    self.addGetAdviceInterestButton.enabled = NO;
    
    /*stretch - instead of allowing user to create new interst it will be automatically created when they click add
     unless the interst already exists then they are just added to the interest*/
    
    
//}
//- (IBAction)onTapAddToGive:(id)sender {
//    NSMutableArray *giveAdviceMutable = [NSMutableArray arrayWithArray:self.giveAdviceInterests];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"InterestModel"];
//    [query whereKey:@"subject" equalTo:self.giveAdviceField.text];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", objects.count);
//            // Do something with the found objects
//            [giveAdviceMutable addObject:objects[0]];
//            self.giveAdviceField.text = nil;
//            self.addGiveAdviceInterestButton.enabled = NO;
//            self.giveAdviceInterests = [NSArray arrayWithArray:giveAdviceMutable];
//        }
//        else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//
    //    [self.giveAdviceInterests addObject:self.giveAdviceField.text];
    //    self.giveAdviceField.text = nil;
    //    self.addGiveAdviceInterestButton.enabled = NO;
    
    
//}

-(void)registerUser  {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    newUser.name = self.nameField.text;
    newUser.bio = self.bioField.text;
    newUser.jobTitle = self.JobTitleField.text;
    newUser.company = self.companyField.text;
    newUser.school = self.institutionField.text;
    newUser.major = self.majorField.text;
    newUser.cityLocation = self.cityField.text;
    newUser.stateLocation = self.stateField.text;
    
    
    /*********************************** User Profile Picture Options ******************************************/
    if(self.chosenProfilePicture == nil){
        self.chosenProfilePicture = [UIImage imageNamed:@"hipster2"];
        newUser.profilePic = [self getPFFileFromImage:self.chosenProfilePicture];
    }
    else {
        
        CGSize newSize = CGSizeMake(100,100);
        
        self.resizedProfilePicture = [self resizeThisImage:self.chosenProfilePicture withSize:newSize];
        newUser.profilePic = [self getPFFileFromImage:self.resizedProfilePicture];
    }
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
        }
    }];
}

/******************************************* Image Picking Things *************************************************/
-(void)addProfilePicture {
    UIImagePickerController* imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.chosenProfilePicture = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage * _Nullable)resizeThisImage:(UIImage * _Nullable)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1000 , 1000)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
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


- (IBAction)onTapRegister:(id)sender {
    [self registerUser];
    
}

- (IBAction)onTapAddProfilePicture:(id)sender {
    
    NSLog( @"Load camera");
    
    [self addProfilePicture];
}

//- (IBAction)createNewInterest:(id)sender {
//    PFObject* newInterest = [PFObject objectWithClassName:@"InterestModel"];
//    if ([self.getAdviceField hasText]){
//        newInterest[@"subject"] = self.getAdviceField.text;
//
//        [newInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if (succeeded) {
//                NSLog(@"New interest saved!");
//                NSString* typed = self.getAdviceField.text;
//                [self searchAutocompleteEntriesWithSubstring:typed];
//                self.addGetAdviceInterestButton.enabled = YES;
//
//            } else {
//                NSLog(@"Error: %@", error.description);
//            }
//        }];
//}
//    if ([self.giveAdviceField hasText]){
//        newInterest[@"subject"] = self.giveAdviceField.text;
//        [newInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//            if (succeeded) {
//                NSLog(@"New interest saved!");
//                NSString* typed = self.giveAdviceField.text;
//                [self searchAutocompleteEntriesWithSubstring:typed];
//                 self.addGiveAdviceInterestButton.enabled = YES;
//
//            } else {
//                NSLog(@"Error: %@", error.description);
//            }
//        }];
//    }
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"segueToTabBarViewController"] ){
        NSLog( @"Test" );
        
        UINavigationController *navigationController = [segue destinationViewController];
        DiscoverTableViewController *discoverTableViewController = (DiscoverTableViewController*) navigationController.topViewController;
        //feedTableViewController.delegate = self;
    }
}


@end
