//
//  EditProfileViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 7/20/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyLabel;
@property (weak, nonatomic) IBOutlet UITextField *majorLabel;
@property (weak, nonatomic) IBOutlet UITextField *schoolLabel;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser* user = [PFUser currentUser];
    self.nameLabel.text = user[@"name"];
    self.jobTitleLabel.text = user[@"jobTitle"];
    self.companyLabel.text = user[@"company"];
    self.majorLabel.text = user[@"major"];
    self.schoolLabel.text = user[@"school"];
    self.emailLabel.text = user[@"email"];
    self.usernameLabel.text = user[@"username"];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendInfoToEditViewController:(NSString *)string{
    [self.nameLabel setText:string];
}

@synthesize delegate = _delegate;
- (IBAction)saveEditsButton:(id)sender {
    [self.delegate changeName:self.nameLabel.text];
    [self.delegate changeMajor:self.majorLabel.text andSchoold:self.schoolLabel.text];
    [self.delegate changeJobTitle:self.jobTitleLabel.text andCompany:self.companyLabel.text];
    //NSLog(@"%@", self.majorLabel.text);
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    ProfileViewController* view = [[ProfileViewController alloc]init];
//    view.delegate = self;
    //calls delegate to update info to profile and parse and dismisses edits view controller
    //viewcontroller.delegate = self;
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
