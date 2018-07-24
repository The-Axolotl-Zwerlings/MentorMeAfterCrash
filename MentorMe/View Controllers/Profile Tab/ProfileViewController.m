//
//  ProfileViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/17/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "GetAdviceTableViewCell.h"
#import "GiveAdviceTableViewCell.h"
#import "EditProfileViewController.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EditProfileViewControllerDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    
    self.giveAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.delegate = self;

    
    self.adviceToGet = [[NSArray alloc]initWithArray:self.user[@"getAdviceInterests"]];
    self.adviceToGive = [[NSArray alloc]initWithArray:self.user[@"giveAdviceInterests"]];

    
    [self loadProfile];
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


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
    
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
