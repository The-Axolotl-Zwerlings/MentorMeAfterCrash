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
#import "SignUpGetAdviceTableViewCell.h"
#import "InterestModel.h"
#import "SignUpGiveAdviceTableViewCell.h"

@interface SignUpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;
@property (weak, nonatomic) IBOutlet UITextField *JobTitleField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *institutionField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *getAdviceField;
@property (weak, nonatomic) IBOutlet UITextField *giveAdviceField;

@property (weak, nonatomic) IBOutlet UIButton *addProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *addGetAdviceInterestButton;
@property (weak, nonatomic) IBOutlet UIButton *addGiveAdviceInterestButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) UIImage* chosenProfilePicture;
@property (nonatomic, strong) UIImage* resizedProfilePicture;
@property (nonatomic, strong) NSMutableArray* getAdviceInterests;
@property (nonatomic, strong) NSMutableArray* giveAdviceInterests;

@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView1;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView2;

@property (strong, nonatomic) NSArray* forTableView;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.getAdviceInterests = [[NSMutableArray alloc] init];
    self.giveAdviceInterests = [[NSMutableArray alloc] init];
    
    
    //Setting Table View Delegate & Data Source
    self.autocompleteTableView1.delegate = self;
    self.autocompleteTableView1.dataSource = self;
    self.autocompleteTableView1.scrollEnabled = YES;
    self.autocompleteTableView1.hidden = YES;

    self.autocompleteTableView2.delegate = self;
    self.autocompleteTableView2.dataSource = self;
    self.autocompleteTableView2.scrollEnabled = YES;
    self.autocompleteTableView2.hidden = YES;
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapAddNew:(id)sender {
    PFObject* newInterest = [PFObject objectWithClassName:@"InterestModel"];
        newInterest[@"subject"] = self.getAdviceField.text;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)onTapAddToGet:(id)sender {
    [self.getAdviceInterests addObject:self.getAdviceField.text];
    self.getAdviceField.text = nil;
}
- (IBAction)onTapAddToGive:(id)sender {
    [self.giveAdviceInterests addObject:self.giveAdviceField.text];
    self.giveAdviceField.text = nil;}

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
    newUser.getAdviceInterests = [[NSArray alloc]initWithArray:self.getAdviceInterests];
    newUser.giveAdviceInterests = [[NSArray alloc]initWithArray:self.giveAdviceInterests];
    
    
    /*********************************** User Profile Picture Options ******************************************/
    if(self.chosenProfilePicture == nil){
        self.chosenProfilePicture = [UIImage imageNamed:@"hipster2"];
        newUser.profilePic = [self getPFFileFromImage:self.chosenProfilePicture];
    }
    else {
        self.resizedProfilePicture = [self resizeThisImage:self.chosenProfilePicture withSize:self.chosenProfilePicture.size];
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

/**************************** Event When Interests Typed **********************************/
- (IBAction)getInterestChanged:(id)sender {
    if(self.getAdviceField.text.length >= 3){
        NSLog(@"greater");
        self.autocompleteTableView1.hidden = NO;
        NSString* typed = self.getAdviceField.text;
        [self searchAutocompleteEntriesWithSubstring:typed];
        //[self.autocompleteTableView1 reloadData];
    }
    else{
        self.autocompleteTableView1.hidden = YES;
    }
}
- (IBAction)giveInterestsChanged:(id)sender {
    if(self.giveAdviceField.text.length >= 3){
        NSLog(@"greater");
        self.autocompleteTableView2.hidden = NO;
        NSString* typed = self.giveAdviceField.text;
        [self searchAutocompleteEntriesWithSubstring:typed];
        //[self.autocompleteTableView2 reloadData];
    }
    else{
        self.autocompleteTableView2.hidden = YES;
    }
}

/******************************* Autocomplete Using Parse ********************************/
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    NSMutableArray* temporary = [[NSMutableArray alloc]init];
    self.forTableView = [[NSArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"InterestModel"];
    [query whereKey:@"subject" hasPrefix:substring];
    [query findObjectsInBackgroundWithBlock:^(NSArray *subjects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", subjects.count);
            for (InterestModel *interest in subjects) {
                [temporary addObject:interest.subject];
                }
            self.forTableView = [NSArray arrayWithArray:temporary];
            
            //we enter both if statements which is uneccesary, so improve this mwthod later
            [self.autocompleteTableView1 reloadData];
            [self.autocompleteTableView2 reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

/************************************** TABLE VIEW  THINGS ******************************/

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.autocompleteTableView1]){
        if(self.forTableView == nil || self.forTableView.count == 0){
        return 1;
        }
        else{
        NSLog(@"%lu", self.forTableView.count);
        return (self.forTableView.count);
        }
    }
    else{
        if(self.forTableView == nil || self.forTableView.count == 0){
            return 1;
        }
        else{
            NSLog(@"%lu", self.forTableView.count);
            return (self.forTableView.count);
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:self.autocompleteTableView1]){

        SignUpGetAdviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableView1" forIndexPath:indexPath];
        cell.addSubjectButton.hidden = YES;
        
        if(self.forTableView == nil || self.forTableView.count == 0){
            NSLog(@"IN IF1");
            cell.addSubjectButton.hidden = NO;
            cell.subjectLabel.hidden = YES;
            return cell;
        }
        else{
            NSLog(@"IN ELSE1");
            cell.addSubjectButton.hidden = YES;
            cell.subjectLabel.text = [self.forTableView objectAtIndex: indexPath.row];
            return cell;
        }
    }
    else{
        SignUpGiveAdviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableView2" forIndexPath:indexPath];
        cell.addSubjectButton.hidden = YES;
        
        if(self.forTableView == nil || self.forTableView.count == 0){
            NSLog(@"IN IF2");
            cell.addSubjectButton.hidden = NO;
            cell.subjectLabel.hidden = YES;
            return cell;
        }
        else{
            NSLog(@"IN ELSE2");
            cell.addSubjectButton.hidden = YES;
            cell.subjectLabel.text = [self.forTableView objectAtIndex: indexPath.row];
            return cell;
        }
    }
}



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
