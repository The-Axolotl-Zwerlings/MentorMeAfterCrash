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
@property (weak, nonatomic) IBOutlet UITextField *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyLabel;
@property (weak, nonatomic) IBOutlet UITextField *majorLabel;
@property (weak, nonatomic) IBOutlet UITextField *schoolLabel;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser* user = [PFUser currentUser];
    self.nameLabel.placeholder = user[@"name"];
    self.jobTitleLabel.placeholder = user[@"jobTitle"];
    self.companyLabel.placeholder = user[@"company"];
    self.majorLabel.placeholder = user[@"major"];
    self.schoolLabel.placeholder = user[@"school"];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
