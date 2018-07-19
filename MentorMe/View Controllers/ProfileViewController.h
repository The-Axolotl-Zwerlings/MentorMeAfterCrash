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

@property (weak, nonatomic) IBOutlet PFImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditBarButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

//methods
-(void)setUIfeatures;

@end
