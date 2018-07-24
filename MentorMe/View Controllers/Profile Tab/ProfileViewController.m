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

@interface ProfileViewController () <EditProfileViewControllerDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    
  /*  self.getAdviceTableView.delegate = self;
    self.giveAdviceTableView.delegate = self;
    self.getAdviceTableView.dataSource = self;
    self.giveAdviceTableView.dataSource = self;*/
    
    self.adviceToGet = [[NSArray alloc]initWithArray:self.user[@"getAdviceInterests"]];
    self.adviceToGive = [[NSArray alloc]initWithArray:self.user[@"giveAdviceInterests"]];

    
    [self loadProfile];
    
    [self loadInterests];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.bannerImageView.image = [UIImage imageNamed:@"33996-5-sunrise-clipart"];
    
}

- (void) didEditProfile {
    
    [self loadProfile];
    
}


- (void) loadInterests {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalView.frame.size.width, self.horizontalView.frame.size.height)];
    
    int x = 0;
    CGRect frame;
    for (int i = 0; i < 10; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if (i == 0) {
            frame = CGRectMake(10, 10, 80, 80);
        } else {
            frame = CGRectMake((i * 80) + (i*20) + 10, 10, 80, 80);
        }
        
        button.frame = frame;
        [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
        [button setTag:i];
        [button setBackgroundColor:[UIColor greenColor]];
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i == 9) {
            x = CGRectGetMaxX(button.frame);
        }
        
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor redColor];
    [self.horizontalView addSubview:scrollView];
    
}

- (void) buttonClicked {
    
    NSLog( @"Button Clicked");
    
}

/*

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
    
}*/


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
