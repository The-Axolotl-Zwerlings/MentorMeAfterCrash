//
//  ProfileViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/17/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self setUIfeatures];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUIfeatures {
    self.usernameLabel.text = self.user[@"username"];
    self.nameLabel.text = self.user[@"name"];
    self.positionLabel.text = self.user[@"jobTitle"];
    self.institutionLabel.text = self.user[@"company"];
    self.bioLabel.text = self.user[@"bio"];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 7.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.file = nil;
    self.profileImageView.file = self.user[@"profilePic"];
    [self.profileImageView loadInBackground];
    
    //self.bannerImageView.file = [UIImage imageNamed:@"hipster2"];
    
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
