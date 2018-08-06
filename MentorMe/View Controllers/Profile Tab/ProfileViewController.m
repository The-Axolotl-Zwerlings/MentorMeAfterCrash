//
//  ProfileViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/17/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "EditProfileViewController.h"

#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "ParseUI.h"

#import "GiveAdviceCollectionViewCell.h"
#import "GetAdviceCollectionViewCell.h"
//#import "ParseManager.h"
#import "InterestModel.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EditProfileViewControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentUser];
    
    self.tabBarController.navigationItem.title = @"Profile";
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 800);
    
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onTapLogout)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit Profile" style:UIBarButtonItemStylePlain target:self action:@selector(onTapEditProfile)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCurrentUser) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];


}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getCurrentUser];
    self.tabBarController.navigationItem.title = @"Profile";
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onTapLogout)];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit Profile" style:UIBarButtonItemStylePlain target:self action:@selector(onTapEditProfile)];
    
}


-(void)onTapEditProfile{
    [self performSegueWithIdentifier:@"EditProfile" sender:self];
}


-(void)onTapLogout{
    
    /*
     
     
     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
     
     NSLog( @"Logging out" );
     
     [self dismissViewControllerAnimated:true completion:nil];
     
     }
     
     */
    
    
    UIAlertController *myalertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logout2];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [myalertController addAction:cancelAction];
    [myalertController addAction:action];
    [self presentViewController:myalertController animated:YES completion:nil];
}

-(void)logout2{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error == nil){
            [self performSegueWithIdentifier:@"backToLogin" sender:self];
            NSLog(@"hey we did it");
        } else{
            NSLog(@"error in logging out");
        }
    }];
}

-(void)getCurrentUser{
    PFQuery *queryforCurrentUser = [PFUser query];
    [queryforCurrentUser includeKey:@"giveAdviceInterests"];
    [queryforCurrentUser includeKey:@"getAdviceInterests"];
    [queryforCurrentUser includeKey:@"username"];
    [queryforCurrentUser whereKey:@"username" equalTo:PFUser.currentUser[@"username"]];
    [queryforCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error == nil && objects[0] != nil){
            
            self.user = objects[0];
            
            //self.title = @"Profile";
            
            self.getAdviceCollectionView.delegate = self;
            self.getAdviceCollectionView.dataSource = self;
            
            self.giveAdviceCollectionView.delegate = self;
            self.giveAdviceCollectionView.dataSource = self;

            
            [self loadProfile];
            [self.refreshControl endRefreshing];
        } else{
            NSLog(@"didn't get user");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadProfile{

    self.adviceToGet = [NSArray arrayWithArray:self.user[@"getAdviceInterests"]];
    self.adviceToGive = [NSArray arrayWithArray:self.user[@"giveAdviceInterests"]];
    
    
    self.usernameLabel.text = self.user[@"username"];
    self.nameLabel.text = self.user[@"name"];
    
    NSString *jobTitleAppend = self.user[@"jobTitle"];
    NSString *companyLabelAppend = self.user[@"company"];
    self.occupationLabel.text = [[jobTitleAppend stringByAppendingString:@" at "] stringByAppendingString:companyLabelAppend];
    
    NSString *majorLabelAppend = self.user[@"major"];
    NSString *schoolLabelAppend = self.user[@"school"];
    self.educationLabel.text = [[[@"Studied " stringByAppendingString:majorLabelAppend] stringByAppendingString:@" at " ] stringByAppendingString: schoolLabelAppend];
    
    NSString *cityLabelAppend = self.user[@"cityLocation"];
    NSString *stateLabelAppend = self.user[@"stateLocation"];
    
    self.locationLabel.text = [[[@"Lives in " stringByAppendingString:cityLabelAppend] stringByAppendingString:@", "] stringByAppendingString:stateLabelAppend];
    
    self.bioLabel.text = self.user.bio;
    
    self.profileImageView.file = self.user.profilePic;
    [self.profileImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error == nil){
            NSLog(@"We did it!");
        }
    }];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void) didEditProfile {
    
    [self getCurrentUser];
    
}





- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if( [collectionView isEqual:self.getAdviceCollectionView] ){
        return self.adviceToGet.count;
    } else {
        return self.adviceToGive.count;
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if( [collectionView isEqual:self.getAdviceCollectionView] ){
        
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        cellA.interest = self.adviceToGet[indexPath.item];
        [cellA reloadInputViews];
        return cellA;
        
    } else {
        
        GiveAdviceCollectionViewCell *cellB = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiveAdviceCollectionViewCell" forIndexPath:indexPath];
        cellB.interest = self.adviceToGive[indexPath.item];
        [cellB reloadInputViews];
        return cellB;
        
        
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"profileEditorSegue"]){
        UIViewController *newController = segue.destinationViewController;
        EditProfileViewController *editorVC = (EditProfileViewController *) newController;
        editorVC.delegate = self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
