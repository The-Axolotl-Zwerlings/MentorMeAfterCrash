//
//  MilestoneViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 8/2/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MilestoneViewController.h"
#import "PFUser+ExtendedUser.h"
#import "CreateAppointmentViewController.h"
@interface MilestoneViewController ()
@property (strong, nonatomic) IBOutlet UILabel *milestoneWith;
@property (strong, nonatomic) id<UITableViewDataSource> dataSource;
@property (strong, nonatomic) id<UITabBarDelegate> delegate;
@property (strong, nonatomic) UIView *lastBar;
@property (strong, nonatomic) NSArray *arrayOfTableViews;
@property (strong, nonatomic) NSArray *arrayOfArrays;
@property (strong, nonatomic) UIButton *scheduleButton;
@property (nonatomic) int meetingNumber;
@property (nonatomic) BOOL notFirstTime;

@end

@implementation MilestoneViewController


-(void)setUI{
    if( self.mentor != nil ){
        self.milestoneWith.text = [@"Milestones With " stringByAppendingString:self.mentor.name];
        self.meetingNumber = [self.milestone.meetingNumber intValue];
        self.arrayOfArrays = self.milestone.arrayOfArrayOfTasks;
    }
    //if there isn't an array for each meeting yet, make them
    NSMutableArray *arrayOfArrayMutable = [NSMutableArray arrayWithArray:self.arrayOfArrays];
    while(arrayOfArrayMutable.count < self.meetingNumber){
        NSArray *fillIn = [[NSArray alloc]init];
        [arrayOfArrayMutable addObject:fillIn];
        
    }
    self.arrayOfArrays = [NSArray arrayWithArray:arrayOfArrayMutable];
    
    NSMutableArray *arrayOfTableViewsMutable = [[NSMutableArray alloc]init];
    
    
    for(int i = 0; i < self.meetingNumber; ++i){
        //if it's the first one and there are no tasks
        if(i == 0 && ((NSArray *)self.arrayOfArrays[0]).count == 0){
            
            [self makeView:YES tasksZero:YES andArray:arrayOfTableViewsMutable andIndex:i];
            
            //if it's the first one and there are tasks
        } else if(i == 0){
            [self makeView:YES tasksZero:NO andArray:arrayOfTableViewsMutable andIndex:i];
            
            //if it's not the first one and there aren't tasks
        } else if(((NSArray *)self.arrayOfArrays[i]).count == 0){
            [self makeView:NO tasksZero:YES andArray:arrayOfTableViewsMutable andIndex:i];
            
            //not the first one and there are tasks
        } else {
            [self makeView:NO tasksZero:NO andArray:arrayOfTableViewsMutable andIndex:i];
            
        }
        
        
        
    }
    
    
    self.arrayOfTableViews = [NSArray arrayWithArray:arrayOfTableViewsMutable];
    
    MilestoneTableView *milestoneTableView = [[MilestoneTableView alloc]initWithTableViews:self.arrayOfTableViews andTasks:self.arrayOfArrays andLastBar:self.lastBar andButton:self.scheduleButton];
    self.dataSource = milestoneTableView;
    self.delegate = milestoneTableView;
    for(int i = 0; i < self.arrayOfTableViews.count; ++i){
        ((UITableView *)self.arrayOfTableViews[i]).dataSource = self.dataSource;
        ((UITableView *)self.arrayOfTableViews[i]).delegate = self.delegate;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1500)];
    if(self.milestone == nil && self.mentor != nil){
        [self getMilestone];
        
    } else{
        [self setUI];
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}
-(void)getMilestone{
    PFQuery *queryForMilestone = [PFQuery queryWithClassName:@"Milestone"];
    [queryForMilestone whereKey:@"mentor" equalTo:self.mentor];
    [queryForMilestone whereKey:@"mentee" equalTo:PFUser.currentUser];
    [queryForMilestone findObjectsInBackgroundWithBlock:^(NSArray * milestone, NSError *error) {
        self.milestone = milestone[0];
        [self setUI];
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.milestone[@"arrayOfArrayOfTasks"] = ((MilestoneTableView *)((UITableView *)self.arrayOfTableViews[0]).dataSource).tasks;
    [self.milestone saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"We saved it!");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"scheduleMeetingSegue"]){
        CreateAppointmentViewController *createAppointmentViewController = [segue destinationViewController];
        createAppointmentViewController.isMentorOfMeeting = NO;
        createAppointmentViewController.otherAttendee = self.mentor;
    }
    NSLog(@"Preparing for segue from milestone");
}


-(void)makeView:(BOOL)first tasksZero:(BOOL)tasksZero andArray:(NSMutableArray *)mutableArray andIndex:(int)i{
    
    //tableview coordinates
    int xPosTable = 81;
    int yPosTable = 170;
    int widthTable = 273;
    int heightTable = 90;
    
    //bars
    int widthBar = 15;
    int xPosBar = 36;
    int yPosBar = 170;
    int heightBar = 90;

    //circle
    int radiusCircle = 41;
    int yPosCircle = 130;
    int xPosCircle = 23;
    //label
    
    if(!first){
        UITableView *previousTable = mutableArray[i-1];
        yPosTable = previousTable.frame.origin.y+previousTable.frame.size.height+40;
        
        yPosBar = previousTable.frame.origin.y+previousTable.frame.size.height+40;
        
        yPosCircle = previousTable.frame.origin.y+previousTable.frame.size.height;
        
        UILabel *meetingLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, previousTable.frame.origin.y+previousTable.frame.size.height+12, 273, 24)];
        meetingLabel.text = [NSString stringWithFormat:@"Meeting #%d",i+1];
        [self.scrollView addSubview:meetingLabel];
        
        
    }
    
    if(!tasksZero){
        
        heightTable = ((NSArray *)self.arrayOfArrays[0]).count*43;
        if(i == self.meetingNumber-1){
            heightTable += 50;
        }
        heightBar = heightTable;
    }
    
    
    UITableView *newTableView = [[UITableView alloc]initWithFrame:CGRectMake(xPosTable,yPosTable,widthTable,heightTable)];
    [mutableArray addObject:newTableView];
    [self.scrollView addSubview:newTableView];
    
    if(i == self.meetingNumber-1){
        UIButton *meetingButton = [[UIButton alloc]initWithFrame:CGRectMake(81, newTableView.frame.origin.y+newTableView.frame.size.height+12, 273, 40)];
        [meetingButton setTitle:@"Schedule next meeting" forState:UIControlStateNormal];
        //[meetingButton setTitleColor:[UIColor colorWithRed:0.59 green:0.87 blue:0.75 alpha:1.0] forState:UIControlStateNormal];
        [meetingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        meetingButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:17.0];
        meetingButton.backgroundColor = [UIColor whiteColor];
        meetingButton.layer.cornerRadius = 16;
        meetingButton.clipsToBounds = YES;
        [meetingButton addTarget:self action:@selector(scheduleMeet) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:meetingButton];
        self.scheduleButton = meetingButton;
    }
    
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(xPosBar, yPosBar, widthBar, heightBar)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:barView];
    
    if(i == (self.meetingNumber-1)){
        self.lastBar = barView;
    }

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(xPosCircle, yPosCircle, radiusCircle, radiusCircle)];
    image.image = [UIImage imageNamed:@"milestoneNoBorder.png"];
    [self.scrollView addSubview:image];
    
}

-(void)scheduleMeet{
    [self performSegueWithIdentifier:@"scheduleMeetingSegue" sender:self];
}

@end
