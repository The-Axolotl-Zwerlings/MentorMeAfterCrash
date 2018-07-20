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
#import "PFUser+ExtendedUser.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MentorDetailsViewController.h"

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
    
    self.title = @"Discover";
    
    NSNumber* noObj = [NSNumber numberWithBool:NO];
    self.filterArray = [[NSArray alloc] initWithObjects:noObj,noObj,noObj,nil];
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    [self fetchFilteredUsersGet];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFilteredUsersGet) forControlEvents:UIControlEventValueChanged];
    [self.discoverTableView insertSubview:self.refreshControl atIndex:0];
    [self.discoverTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchFilteredUsersGet{
    PFQuery *usersQuery = [PFUser query];
    [usersQuery includeKey:@"giveAdviceInterests"];
    [usersQuery whereKey:@"user" notEqualTo:PFUser.currentUser];
    usersQuery.limit = 20;
    [usersQuery orderByDescending:@"createdAt"];
    /*if([self.filterArray[0] boolValue]){
        [usersQuery whereKey:@"school" equalTo:PFUser.currentUser.school];
    }
    if([self.filterArray[1] boolValue]){
        [usersQuery whereKey:@"company" equalTo:PFUser.currentUser.company];
     }*/
//    if([self.filterArray[2] boolValue]){
//        [usersQuery whereKey:@"location" equalTo:PFUser.currentUser.location];
//    }
    
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
    [usersQuery includeKey:@"getAdviceInterests"];
    [usersQuery whereKey:@"user" notEqualTo:PFUser.currentUser];
    usersQuery.limit = 20;
    [usersQuery orderByDescending:@"createdAt"];
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
    
    NSMutableArray *old = [NSMutableArray arrayWithArray:self.filterArray];
    [old replaceObjectAtIndex:0 withObject:school];
    NSArray *newAr = [NSArray arrayWithArray:old];
    self.filterArray = newAr;

    NSMutableArray *old1 = [NSMutableArray arrayWithArray:self.filterArray];
    [old1 replaceObjectAtIndex:1 withObject:company];
    NSArray *newAr1 = [NSArray arrayWithArray:old1];
    self.filterArray = newAr1;


    NSMutableArray *old2 = [NSMutableArray arrayWithArray:self.filterArray];
    [old replaceObjectAtIndex:2 withObject:location];
    NSArray *newAr2 = [NSArray arrayWithArray:old2];
    self.filterArray = newAr2;
    
}






- (IBAction)onEdit:(UISegmentedControl *)sender {
    
    //if we are going to give advice
    if(self.mentorMenteeSegControl.selectedSegmentIndex == 1){
        NSLog( @"Showing people who can give advice" );
        self.getAdvice = NO;
        [self fetchFilteredUsersGive];
        
    } else{
        NSLog( @"Showing people need advice" );
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
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            
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
        filterViewController.filterPreferences = self.filterArray;
        filterViewController.getAdvice = self.getAdvice;
    } else if ( [segue.identifier isEqualToString:@"segueToMentorDetailsViewController"]    )  {
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.discoverTableView indexPathForCell:tappedCell];
        PFUser *incomingMentor = self.filteredUsers[indexPath.row];
        MentorDetailsViewController *mentorDetailsViewController = [segue destinationViewController];
        mentorDetailsViewController.mentor = incomingMentor;
        
        
    }
}


@end