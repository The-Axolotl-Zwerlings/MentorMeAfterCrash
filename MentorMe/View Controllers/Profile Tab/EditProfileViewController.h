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
-(void)changeName:(NSString *)newname;
-(void)changeMajor:(NSString *)newmajor andSchoold:(NSString*)newSchool;
-(void)changeJobTitle:(NSString *)newJobTitle andCompany:(NSString*)newCompany;
@end

@interface EditProfileViewController : UIViewController

@property (nonatomic, weak) id<profileEditorDelegate> delegate;

@end
