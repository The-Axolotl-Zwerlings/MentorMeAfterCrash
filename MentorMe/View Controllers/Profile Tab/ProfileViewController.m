//
//  ProfileViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/17/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "CreateAppointmentViewController.h"
#import "EditProfileViewController.h"
#import "EditInterestsViewController.h"
#import "GiveAdviceCollectionViewCell.h"
#import "GetAdviceCollectionViewCell.h"
#import "InterestModel.h"
#import "MilestoneViewController.h"
#import "Milestone.h"
#import "MentorMilestoneCell.h"
#import "ProfileDataDelegate.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "ParseUI.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Review.h"
#import "SignUpViewController.h"
#import "TLTagsControl.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EditProfileViewControllerDelegate, GoToMilestone>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PFImageView *largeImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UIView *largeImageView;
@property (weak, nonatomic) IBOutlet UIView *MentorsView;

@property (strong, nonatomic) IBOutlet UIButton *editInterestsButton;
@property (strong, nonatomic) id<UICollectionViewDataSource> dataSource;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCurrentUser];
    
    self.tabBarController.navigationItem.title = @"Profile";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onTapLogout)];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,860);
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCurrentUser) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
    
    self.dataSource = [[ProfileDataDelegate alloc]init:self.mentorsCollectionView andSource:self] ;
    self.mentorsCollectionView.dataSource = self.dataSource;
    self.mentorsCollectionView.layer.cornerRadius = 12;
    UICollectionViewFlowLayout *layout = self.mentorsCollectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12;
    CGFloat mentorsPerLine = 3;
    CGFloat itemWidth = (self.mentorsCollectionView.frame.size.width - (mentorsPerLine-1)*layout.minimumInteritemSpacing)/mentorsPerLine ;
    CGFloat itemHeight = 140;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getCurrentUser];
    self.tabBarController.navigationItem.title = @"Profile";
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onTapLogout)];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleImageTap:)];
    [self.profileImageView addGestureRecognizer:singleFingerTap];
    
//    UITapGestureRecognizer *dismissFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(dismissProfilePicture:)];
//    [self.view addGestureRecognizer:dismissFingerTap];
}
//- (void)onTapProfilePicture:(UITapGestureRecognizer *)recognizer
//{
//    [self.view addSubview:self.largeImageView];
//    [self.largeImageView setFrame:CGRectMake(self.view.frame.origin.x+37.5, self.view.frame.origin.y+127, 300, 300)];
//    self.largeImage.file = self.user.profilePic;
//    [self.largeImage loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
//        if(error == nil){
//            NSLog(@"Large Profile Picture loaded!");
//        }
//    }];
//
//
//}
//- (void)dismissProfilePicture:(UITapGestureRecognizer *)recognizer
//{
//    [self.largeImageView removeFromSuperview];
//}
-(void)handleImageTap: (UITapGestureRecognizer *) recognizer{
    
    UIViewController *bbp=[[UIViewController alloc]init];
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:bbp];
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
                                 @"Back" style:UIBarButtonItemStylePlain target:
                                 self action:@selector(myButtonClicked:)];
    [self.navigationController presentViewController:passcodeNavigationController animated:YES completion:nil];
    bbp.view.backgroundColor = UIColor.blackColor;
    bbp.navigationController.navigationBar.barTintColor = UIColor.blackColor;
    bbp.navigationItem.leftBarButtonItem = myNavBtn;
    PFImageView* large = [[PFImageView alloc]init];
    large.translatesAutoresizingMaskIntoConstraints = false;
    [bbp.view addSubview:large];
    large.file = self.user.profilePic;
    [large.widthAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    [large.heightAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    
    [large.centerXAnchor constraintEqualToAnchor:bbp.view.centerXAnchor].active = YES;
    [large.centerYAnchor constraintEqualToAnchor:bbp.view.centerYAnchor].active = YES;
}

- (void)myButtonClicked:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.getAdviceCollectionView reloadData];
    [self.giveAdviceCollectionView reloadData];
    [(ProfileDataDelegate *)self.dataSource queryforMentors];
     
    if( [self.mentorsCollectionView numberOfItemsInSection:0] == 0 ){
        self.MentorsView.hidden = YES;
        CGFloat newHeight = self.giveAdviceCollectionView.frame.size.height + self.giveAdviceCollectionView.frame.origin.y + 12;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,newHeight);
    } else {
        self.MentorsView.hidden = NO;
        CGFloat newHeight = self.MentorsView.frame.size.height + self.MentorsView.frame.origin.y;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,newHeight);
    }
    
    self.headerImageView.layer.shadowOffset = CGSizeMake(0, 5);
    self.headerImageView.layer.shadowOpacity = 1;
    self.headerImageView.layer.shadowRadius = 4;
    self.headerImageView.layer.shadowColor = UIColor.grayColor.CGColor;
     
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
            NSLog(@"User profile picture loaded!");
        }
    }];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.22 green:0.97 blue:0.66 alpha:1.0].CGColor;
    [self getRating];
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
    
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
    
    if([collectionView isEqual:self.getAdviceCollectionView]){
        cellA.interest = self.adviceToGet[indexPath.item];
    } else{
        cellA.interest = self.adviceToGive[indexPath.item];
    }
    [cellA layoutInterestsStory];
    return cellA;
    
}

- (void)gotoMilestone:(PFUser *)mentor{
    [self performSegueWithIdentifier:@"ProfiletoMilestone" sender:mentor];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel *modelA;
    if( [collectionView isEqual: self.getAdviceCollectionView] ){
        modelA = self.adviceToGet[indexPath.row];
    } else {
        modelA = self.adviceToGive[indexPath.row];
    }
    
    NSString *testString = modelA.subject;
    
    CGSize textSize = [testString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0f]}];
    textSize.height += 8;
    textSize.width += 24;
    return textSize;
}

-(void)getRating{
    __block NSNumber *starRating = nil;
    
    PFUser *myUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query includeKey:@"reviewee"];
    [query whereKey:@"reviewee" equalTo:myUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError * _Nullable error) {
        if(reviews){
            NSNumber *no = [NSNumber numberWithBool:NO];
            NSMutableArray *cumulativeCompliments = [[NSMutableArray alloc] initWithObjects:no,no,no,no,no,nil];
            float totalRating = 0;
            for(Review *review in reviews){
                totalRating += [review.rating floatValue];
                
                
                for(int i = 0; i < 5; ++i){
                    if(review.complimentsArray[i] == [NSNumber numberWithBool:YES]){
                        NSNumber *newTotalOfCompliment = [NSNumber numberWithFloat:([cumulativeCompliments[i] floatValue] + 1)];
                        [cumulativeCompliments replaceObjectAtIndex:i withObject:newTotalOfCompliment];
                    }
                }
                
            }
            starRating = [NSNumber numberWithFloat:totalRating/reviews.count];
            
            if( isnan([starRating doubleValue]) == 0 ){
                self.ratingView.hidden = false;
                NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", [starRating doubleValue]];
                self.ratingLabel.text = [NSString stringWithFormat:@"%@", formattedNumber];
                
                self.ratingView.layer.cornerRadius = 13;
                self.ratingView.layer.masksToBounds = YES;
                
            } else {
                self.ratingView.hidden = true;
            }
            
        }
    }];
    
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"profileEditorSegue"]){
        UIViewController *newController = segue.destinationViewController;
        EditProfileViewController *editorVC = (EditProfileViewController *) newController;
        editorVC.delegate = self;
    } else if([segue.identifier isEqualToString:@"toEditInterests"]){
        
        // EditProfileViewController* instance = [segue destinationViewController];
        self.dataPasserDelegate = [segue destinationViewController];
        //alter original storyboard
        [self.dataPasserDelegate update:self.adviceToGet and: self.adviceToGive];
    } else if([segue.identifier isEqualToString:@"ProfiletoMilestone"]){
        
        MilestoneViewController *milestoneViewController = [segue destinationViewController];
        milestoneViewController.mentor = sender;
        milestoneViewController.mentee = PFUser.currentUser;
        
    } else if([segue.identifier isEqualToString:@"learnAbout"]){
        CreateAppointmentViewController *createViewController = [segue destinationViewController];
        NSLog(@"hit create");
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
