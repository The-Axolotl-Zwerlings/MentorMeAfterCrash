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

#import "InterestModel.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EditProfileViewControllerDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentUser];


}

//- (void) viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//
//    [self loadProfile];
//
//}

-(void)getCurrentUser{
    PFQuery *queryforCurrentUser = [PFUser query];
    [queryforCurrentUser includeKey:@"giveAdviceInterests"];
    [queryforCurrentUser includeKey:@"getAdviceInterests"];
    [queryforCurrentUser includeKey:@"username"];
    [queryforCurrentUser whereKey:@"username" equalTo:PFUser.currentUser[@"username"]];
    [queryforCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error == nil && objects[0] != nil){
            
            self.user = objects[0];
            
            self.title = @"Profile";
            
            self.getAdviceCollectionView.delegate = self;
            self.getAdviceCollectionView.dataSource = self;
            
            self.giveAdviceCollectionView.delegate = self;
            self.giveAdviceCollectionView.dataSource = self;
            
            
            self.adviceToGet = [NSArray arrayWithArray:self.user[@"getAdviceInterests"]];
            self.adviceToGive = [NSArray arrayWithArray:self.user[@"giveAdviceInterests"]];
            [self loadProfile];
        } else{
            NSLog(@"didn't get user");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadProfile {
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
    
    
    
    
    self.bannerImageView.layer.borderWidth = 2.0f;
    self.bannerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bioLabel.text = self.user[@"bio"];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.file = nil;
    self.profileImageView.file = self.user[@"profilePic"];
    [self.profileImageView loadInBackground];
    
}

- (void) didEditProfile {
    
    [self loadProfile];
    
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
