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

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    
    self.getAdviceTableView.delegate = self;
    self.giveAdviceTableView.delegate = self;
    self.getAdviceTableView.dataSource = self;
    self.giveAdviceTableView.dataSource = self;
    
    self.adviceToGet = [[NSArray alloc]initWithArray:self.user[@"getAdviceInterests"]];
    self.adviceToGive = [[NSArray alloc]initWithArray:self.user[@"giveAdviceInterests"]];

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
    self.jobTitleLabel.text = self.user[@"jobTitle"];
    self.companyLabel.text = self.user[@"company"];
    self.majorLabel.text = self.user[@"major"];
    self.schoolLabel.text = self.user[@"school"];
    self.bioLabel.text = self.user[@"bio"];
//    self.whiteView.layer.cornerRadius = 5.0;
//    [self.whiteView setClipsToBounds:YES];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 7.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.file = nil;
    self.profileImageView.file = self.user[@"profilePic"];
    [self.profileImageView loadInBackground];
    
    self.bannerImageView.image = [UIImage imageNamed:@"33996-5-sunrise-clipart"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.getAdviceTableView){
        return self.adviceToGet.count;
    }
    else{
        return self.adviceToGive.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.getAdviceTableView){
        GetAdviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
        cell.interestLabel.text = [self.adviceToGet objectAtIndex: indexPath.row];
        
        return cell;
    }
    else{
        GiveAdviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
        cell.interestLabel.text = [self.adviceToGive objectAtIndex: indexPath.row];
        
        return cell;
    }
    
    
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
