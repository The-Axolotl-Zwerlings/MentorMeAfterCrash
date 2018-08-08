//
//  LoginViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@end

@implementation LoginViewController
- (IBAction)tapOutside:(id)sender {
    if([self.passwordField isFirstResponder]){
        [self.passwordField resignFirstResponder];
    } else if([self.usernameField isFirstResponder]){
        [self.usernameField resignFirstResponder];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*self.LogInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.LogInButton.layer.borderWidth = 1;
    self.RegisterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.RegisterButton.layer.borderWidth = 1;
    
    self.LogInButton.layer.cornerRadius = 10;
    self.LogInButton.layer.masksToBounds = YES;
    self.RegisterButton.layer.cornerRadius = 10;
    self.RegisterButton.layer.masksToBounds = YES;*/
    
    self.backgroundImageView.layer.shadowOffset = CGSizeMake(0, 5);
    self.backgroundImageView.layer.shadowRadius = 5;
    self.backgroundImageView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.backgroundImageView.layer.shadowOpacity = 1;
    
    
    UIImageView *newImageA = [[UIImageView alloc] initWithFrame:CGRectMake(self.usernameField.frame.origin.x, self.usernameField.frame.origin.y + self.usernameField.frame.size.height, self.usernameField.frame.size.width, 1)];
    newImageA.backgroundColor = [UIColor blackColor];
    
    UIImageView *newImageB = [[UIImageView alloc] initWithFrame:CGRectMake(self.passwordField.frame.origin.x, self.passwordField.frame.origin.y + self.passwordField.frame.size.height, self.passwordField.frame.size.width, 1)];
    newImageA.backgroundColor = [UIColor blackColor];
    newImageB.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:newImageA];
    [self.view addSubview:newImageB];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginUser  {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)onTapLogin:(id)sender {
    
    [self loginUser];
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
