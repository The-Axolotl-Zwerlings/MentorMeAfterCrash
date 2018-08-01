//
//  ProfileViewController.h
//  MentorMe
//
//  Created by Nico Salinas on 7/17/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI/ParseUI.h"
#import "Parse/Parse.h"


@interface ProfileViewController : UIViewController
//outlets for everything in the viewcontroller

@property (strong, nonatomic) PFUser* user;

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UIView *profileScreenView;

@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) NSArray* adviceToGet;
@property (strong, nonatomic) NSArray* adviceToGive;

@property (weak, nonatomic) IBOutlet UICollectionView *giveAdviceCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *getAdviceCollectionView;

//methods
-(void)loadProfile;

@end
