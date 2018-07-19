//
//  DiscoverTableViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "DiscoverCell.h"
#import "FilterViewController.h"
#import "Parse.h"
@interface DiscoverTableViewController () <UITableViewDelegate,UITableViewDataSource,FilterDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *mentorMenteeSegControl;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) NSArray *filteredUsers;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *filterArray;
@property (nonatomic) BOOL getAdvice;
@end

@implementation DiscoverTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.getAdvice = YES;
    
    NSNumber* noObj = [NSNumber numberWithBool:NO];
    self.filterArray = [[NSArray alloc] initWithObjects:noObj,noObj,noObj,noObj,nil];
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    [self fetchFilteredUsersGet];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFilteredUsersGet) forControlEvents:UIControlEventValueChanged];
    
    [self.discoverTableView insertSubview:self.refreshControl atIndex:0];
    
    [self.discoverTableView reloadData];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.discoverTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchFilteredUsersGet{
    PFQuery *usersQuery = [PFUser query];
    usersQuery.limit = 20;
    //[usersQuery orderByDescending:@"createdAt"];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
        
        if(users){
            
            self.filteredUsers = users;
            [self.discoverTableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"WE GOT THE USERS 😇");
        } else{
            NSLog(@"didn't get the users 🙃");
        }
        
    }];
    
}

-(void)fetchFilteredUsersGive{
    PFQuery *usersQuery = [PFUser query];
    usersQuery.limit = 2;
    //[usersQuery orderByDescending:@"createdAt"];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
        
        if(users){
            
            self.filteredUsers = users;
            [self.discoverTableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"WE GOT THE USERS 😇");
        } else{
            NSLog(@"didn't get the users 🙃");
        }
        
    }];
    
}

- (void)didChangeSchool:(NSNumber *)school withCompany:(NSNumber *)company andLocation:(NSNumber *)location{
    
}

- (IBAction)onEdit:(UISegmentedControl *)sender {
    
    //if we are going to give advice
    if(self.mentorMenteeSegControl.selectedSegmentIndex == 1){
        self.getAdvice = NO;
        [self fetchFilteredUsersGive];
        
    } else{
        self.getAdvice = YES;
        [self fetchFilteredUsersGet];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    [cell layoutCell:self.filteredUsers[indexPath.row]];
    
    
    return cell;
}

- (IBAction)logoutButtonAction:(UIButton *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error == nil){
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"hey we did it");
        } else{
            NSLog(@"error in logging out");
        }
    }];
}

- (IBAction)logoutAction:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error == nil){
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"hey we did it");
        } else{
            NSLog(@"error in logging out");
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"filterSegue"]){
        UINavigationController *navControl = [segue destinationViewController];
        FilterViewController *filterViewController = (FilterViewController *)navControl.topViewController;
        filterViewController.delegate = self;
    }
}


@end
