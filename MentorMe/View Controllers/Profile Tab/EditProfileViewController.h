//
//  EditProfileViewController.h
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 7/20/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "Parse/Parse.h"

@protocol profileEditorDelegate <NSObject>
-(void)didEditProfile;
@end

@interface EditProfileViewController : UIViewController

@property (nonatomic, weak) id<profileEditorDelegate> delegate;

@end
