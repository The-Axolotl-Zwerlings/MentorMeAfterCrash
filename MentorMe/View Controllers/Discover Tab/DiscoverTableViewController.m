//
//  DiscoverTableViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/12/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//
#import "AppDelegate.h"
#import "DiscoverTableViewController.h"
#import "DiscoverCell.h"
#import "FilterViewController.h"
#import "HMSegmentedControl.h"
#import "InterestModel.h"
#import "LocationApiManager.h"
#import "LoginViewController.h"
#import "MentorDetailsViewController.h"
#import "MBProgressHUD.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"


@interface DiscoverTableViewController () <UITableViewDelegate,UITableViewDataSource,FilterDelegate>{
    UITableView *getTableView;
    UITableView *giveTableView;
}
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL filtering;
@property (nonatomic) BOOL getAdvice;
@property (nonatomic, assign) NSInteger* noOfNotifications;
@property (nonatomic, strong) UIView* counterView;
@property (nonatomic, strong) UILabel* couterLabel;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation DiscoverTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //notification count
    self.counterView = [[UIView alloc]initWithFrame:CGRectMake(35, 0, 26, 26)];
    [self.counterView setBackgroundColor:UIColor.redColor];
    [self.counterView.layer setCornerRadius:self.counterView.frame.size.width/2];
    [self.counterView.layer setMasksToBounds:YES];
    self.couterLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 0, 25, 25)];
    self.couterLabel.textColor = UIColor.whiteColor;
    
    self.tabBarController.navigationItem.title = @"Discover";
    self.filtersToSearchGetWith = [[NSMutableArray alloc] init];
    self.filtersToSearchGiveWith = [[NSMutableArray alloc] init];
    
    [self fetchAllUsersWithSchool:NO andCompany:NO];
    [self initSegmentedControl];
    [self initScrollView];
    [self initTableViews];
    [self loadBarButtons];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchAllUsersWithSchool:andCompany:) forControlEvents:UIControlEventValueChanged];
    
    [getTableView insertSubview:self.refreshControl atIndex:0];
    
}

-(void)notificationsCount{
    PFQuery* query = [PFQuery queryWithClassName:@"Notifications"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError * _Nullable error) {
        if (!error) {
            if(objects.count != 0){
            [self.navigationController.navigationBar addSubview:self.counterView];
            [self.navigationController.navigationBar addSubview:self.couterLabel];
            self.couterLabel.text = [NSString stringWithFormat: @"%ld", objects.count];
            }
            else{
                [self.couterLabel removeFromSuperview];
                [self.counterView removeFromSuperview];
            }
            }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Discover";
    /**/

    [self loadBarButtons];
    
    [giveTableView reloadData];
    [getTableView reloadData];
    
    [self notificationsCount];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(notificationsCount)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) loadBarButtons {
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    UIImage *tabImage = [UIImage imageNamed:@"equalizer-1"];
    self.tabBarController.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:tabImage style:UIBarButtonItemStylePlain target:self action:@selector(segueToFilters)];
    /**/
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"bell"] style:UIBarButtonItemStylePlain target:
                                 self action:@selector(myButtonClicked:)];
    self.tabBarController.navigationItem.leftBarButtonItem = myNavBtn; self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.41 alpha:1.0];
    /**/
}

/**/
-(void) myButtonClicked: (UIBarButtonItem*)sender{
    [self performSegueWithIdentifier:@"segueToNotifications" sender:nil];
}
/**/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)fetchAllUsersWithSchool:(NSNumber *)school andCompany:(NSNumber *)company{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if( [PFUser currentUser] ){
        
        
        
        PFQuery *usersQuery = [PFUser query];
        NSArray *stringsToQueryAllUsers = [[NSArray alloc] initWithObjects:@"profilePic", @"giveAdviceInterests", @"getAdviceInterests", nil];
        [usersQuery includeKeys:stringsToQueryAllUsers];
        [usersQuery whereKey:@"username" notEqualTo:PFUser.currentUser.username];
        if(school == [NSNumber numberWithBool:YES]){
            [usersQuery whereKey:@"school" equalTo:PFUser.currentUser.school];
        }
        if(company == [NSNumber numberWithBool:YES]){
            [usersQuery whereKey:@"company" equalTo:PFUser.currentUser.company];
        }
        usersQuery.limit = 20;
        [usersQuery orderByDescending:@"createdAt"];
        [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError * error) {
            if(users){
                self.allUsersFromQuery = users;
                [giveTableView reloadData];
                [getTableView reloadData];
                [self.refreshControl endRefreshing];
                
                NSLog(@"WE GOT THE USERS 😇");
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } else{
                //NSLog(@"didn't get the users 🙃");
            }
        }];
    }
    
}

- (void) fetchUsersWithSelectedInterests: (BOOL)isFilteringGetInterests {
    if(isFilteringGetInterests){
        NSSet *myUserInterestsSet = [NSMutableSet setWithArray:self.filtersToSearchGetWith];
        self.filterGet = nil;
        for(PFUser *user in self.allUsersFromQuery){
            NSSet *otherUserInterests = [NSSet setWithArray:[InterestModel giveMeSubjects:user.giveAdviceInterests]];
            BOOL intersectionOfInterests = [myUserInterestsSet intersectsSet:otherUserInterests];
            if( intersectionOfInterests == YES){
                if( self.filterGet == nil ){
                    self.filterGet = [[NSMutableArray alloc] initWithObjects:user, nil];
                    NSLog( @"Created a new array" );
                } else {
                    [self.filterGet addObject:user];
                }
            }
        }
    } else{
        NSSet *myUserInterestsSet = [NSSet setWithArray:self.filtersToSearchGiveWith];
        self.filterGive = nil;
        for(PFUser *user in self.allUsersFromQuery){
            NSSet *otherUserInterests = [NSSet setWithArray:[InterestModel giveMeSubjects:user.getAdviceInterests]];
            BOOL intersectionOfInterests = [myUserInterestsSet intersectsSet:otherUserInterests];
            if( intersectionOfInterests == YES){
                if( self.filterGive == nil ){
                    self.filterGive = [[NSMutableArray alloc] initWithObjects:user, nil];
                    NSLog( @"Created a new array" );
                } else {
                    [self.filterGive addObject:user];
                }
            }
        }
    }
    
    
}


-(void)fetchUsersNearbyCurrentUser:(NSArray *)users{
    NSString *destination = [NSString stringWithFormat:@"%@,%@", PFUser.currentUser.cityLocation,PFUser.currentUser.stateLocation];
    NSMutableArray *oldArray = [[NSMutableArray alloc] init];
    dispatch_queue_t locationQueue = dispatch_queue_create("location Queue",NULL);
    
    for(PFUser *user in users){
        
        dispatch_async(locationQueue, ^{
            NSString *origin = [NSString stringWithFormat:@"%@,%@", user.cityLocation,user.stateLocation];
            LocationApiManager *manager = [LocationApiManager new];
            [manager fetchDistanceWithOrigin:origin andEnd:destination andCompletion:^(NSDictionary *elementDic, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumber *distance = (NSNumber *)elementDic[@"value"];
                    if([distance floatValue] < 50){
                        [oldArray addObject:user];
                        NSLog(@"Added a new user %@", user.name);
                        NSLog(@"%lu",oldArray.count);
                    }
                    self.allUsersFromQuery = (NSMutableArray *)[NSArray arrayWithArray:oldArray];
                    NSLog(@"%lu", (unsigned long)self.allUsersFromQuery.count);
                    [giveTableView reloadData];
                    [getTableView reloadData];
                });
                //                NSNumber *distance = (NSNumber *)elementDic[@"value"];
                //                if([distance floatValue] < 50){
                //                    [oldArray addObject:user];
                //                    NSLog(@"Added a new user %@", user.name);
                //                    NSLog(@"%lu",oldArray.count);
                //                }
            }];
            //NSLog(@"%lu",oldArray.count);
        });
        
        
        
    }
    //    self.filteredUsers = [NSArray arrayWithArray:oldArray];
    //    NSLog(@"%lu", (unsigned long)self.filteredUsers.count);
    //    [self.discoverTableView reloadData]
}




- (void) segueToFilters {
    [self performSegueWithIdentifier:@"filterSegue" sender:self];
}


/*** DELEGATE METHODS  ***/
- (void) didChangeFilters:(NSMutableArray *) incomingGetInterests withGiveInterests:(NSMutableArray *) incomingGiveInterests withGetIndex:(NSMutableArray *)incomingGetIndices withGiveIndex:(NSMutableArray *)incomingGiveIndices andOtherFilterArray:(NSArray *)otherFilterArray{
    
    self.otherFiltersArray = otherFilterArray;
    //school, company, location
    if(otherFilterArray[0] == [NSNumber numberWithBool:YES] || otherFilterArray[1] == [NSNumber numberWithBool:YES]){
        [self fetchAllUsersWithSchool:otherFilterArray[0] andCompany:otherFilterArray[1]];
    } else{
        [self fetchAllUsersWithSchool:[NSNumber numberWithBool:NO] andCompany:[NSNumber numberWithBool:NO]];
    }
    if(otherFilterArray[2] == [NSNumber numberWithBool:YES]){
        [self fetchUsersNearbyCurrentUser:self.allUsersFromQuery];
    }
    
    self.getIndex = incomingGetIndices;
    self.giveIndex = incomingGiveIndices;
    
    self.filtering = NO;
    if(incomingGetInterests.count != 0 || incomingGiveInterests.count != 0){
        self.filtering = YES;
    }
    if( incomingGetInterests.count != 0){
        self.filtersToSearchGetWith = nil;
        self.filtersToSearchGetWith = incomingGetInterests;
        [self fetchUsersWithSelectedInterests:YES];
    }
    if ( incomingGiveInterests.count != 0 ){
        self.filtersToSearchGiveWith = nil;
        self.filtersToSearchGiveWith = incomingGiveInterests;
        [self fetchUsersWithSelectedInterests:NO];
    }
    
    
    
    
}




/*** SEGMENTED CONTROL ***/

- (void) initSegmentedControl{
    // Tying up the segmented control to a scroll view
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(12, 12, viewWidth-24, 40)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

    self.segmentedControl.sectionTitles = @[@"Get Advice", @"Give Advice"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedControl.selectionIndicatorColor = [UIColor grayColor];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentedControl.tag = 2;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl];
}

- (void) initScrollView {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, 500)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, 500);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) animated:NO];
    [self.view addSubview:self.scrollView];
}


- (void) initTableViews {
    getTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
    [getTableView registerClass:[DiscoverCell class] forCellReuseIdentifier:@"DiscoverCell"];
    getTableView.delegate = self;
    getTableView.dataSource = self;
    [getTableView setRowHeight:184];
    getTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:getTableView];
    
    giveTableView = [[UITableView alloc] initWithFrame:CGRectMake(375, 0, 375, 500)];
    [giveTableView registerClass:[DiscoverCell class] forCellReuseIdentifier:@"DiscoverCell"];
    giveTableView.delegate = self;
    giveTableView.dataSource = self;
    [giveTableView setRowHeight:184];
    giveTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:giveTableView];
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    if( segmentedControl.selectedSegmentIndex == 0 ){
        [getTableView reloadData];
    } else{
        [giveTableView reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    NSLog(@"Slided to index %ld", page);
    if( page == 0 ){
        [getTableView reloadData];
    } else{
        [giveTableView reloadData];
    }

}

/*** SEGUE METHODS ***/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"filterSegue"]){
        UINavigationController *navControl = [segue destinationViewController];
        FilterViewController *filterViewController = (FilterViewController *)navControl.topViewController;
        filterViewController.delegate = self;
        filterViewController.getAdvice = self.getAdvice;
        
        filterViewController.selectedIndexGive = self.giveIndex;
        filterViewController.selectedIndexGet = self.getIndex;
        
        filterViewController.selectedGetFilters = self.filtersToSearchGetWith;
        filterViewController.selectedGiveFilters = self.filtersToSearchGiveWith;
        
        filterViewController.otherFiltersArray = self.otherFiltersArray;
    } else if ( [segue.identifier isEqualToString:@"segueToMentorDetailsViewController"]    )  {
        NSIndexPath *indexPath = sender;
        PFUser *incomingMentor;
        if(self.segmentedControl.selectedSegmentIndex == 0 && self.filtersToSearchGetWith.count != 0){
            incomingMentor = self.filterGet[indexPath.row];
        } else if(self.segmentedControl.selectedSegmentIndex == 1 && self.filtersToSearchGiveWith.count != 0){
            incomingMentor = self.filterGive[indexPath.row];
        } else{
            incomingMentor = self.allUsersFromQuery[indexPath.row];
        }
        
        
        NSLog(@"Tapped %@", incomingMentor.name );
        
        MentorDetailsViewController *mentorDetailsViewController = [segue destinationViewController];
        mentorDetailsViewController.mentor = incomingMentor;
        if(self.segmentedControl.selectedSegmentIndex == 0){
            mentorDetailsViewController.isMentorOfMeeting = NO;
        } else{
            mentorDetailsViewController.isMentorOfMeeting = YES;
        }
    }
}


/***** TABLE VIEW ******/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == getTableView && self.filtersToSearchGetWith.count != 0) {
        
        return self.filterGet.count;
    } else if (tableView == giveTableView && self.filtersToSearchGiveWith.count != 0) {
        
        return self.filterGive.count;
    } else {
        return self.allUsersFromQuery.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DiscoverCell" forIndexPath:indexPath];
    
    [cell targetForAction:@selector(tableView:didSelectRowAtIndexPath:) withSender:nil];
    
    cell.selectedIndex = self.segmentedControl.selectedSegmentIndex;
    if(cell.selectedIndex == 0 && self.filtersToSearchGetWith.count != 0 && tableView == getTableView){
        cell.userForCell = self.filterGet[indexPath.row];
    } else if(cell.selectedIndex == 1 && self.filtersToSearchGiveWith.count != 0 && tableView == giveTableView){
        cell.userForCell = self.filterGive[indexPath.row];
        
    } else{
        cell.userForCell = self.allUsersFromQuery[indexPath.row];
    }
    cell.incomingGetInterests = cell.userForCell.getAdviceInterests;
    cell.incomingGiveInterests = cell.userForCell.giveAdviceInterests;
    cell.giveSet = [NSSet setWithArray:self.filtersToSearchGiveWith];
    cell.getSet = [NSSet setWithArray:self.filtersToSearchGetWith];
    if(cell.userForCell != nil ){
        [cell loadCell];
        [cell loadCollectionViews];
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueToMentorDetailsViewController" sender:indexPath];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"stoped");
    [super viewDidDisappear:(BOOL)animated];
    [self.timer invalidate];
    [self.couterLabel removeFromSuperview];
    [self.counterView removeFromSuperview];
}
@end
