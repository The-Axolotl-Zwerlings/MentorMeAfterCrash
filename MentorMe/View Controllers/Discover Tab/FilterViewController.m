//
//  FilterViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "FilterViewController.h"
#import "Parse.h"
#import "PFUser+ExtendedUser.h"

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISwitch *schoolSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *companySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *interestsSwitchs;

//school, company, location

@end

@implementation FilterViewController
- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interestsTableView.delegate = self;
    self.interestsTableView.dataSource = self;
    // Do any additional setup after loading the view.
    if(self.filterPreferences == nil){
        self.filterPreferences = [NSArray arrayWithObjects:@(0),@(0),@(0),nil];
    }
    [self.schoolSwitch setOn:[self.filterPreferences[0] boolValue]];
    [self.companySwitch setOn:[self.filterPreferences[1] boolValue]];
    [self.locationSwitch setOn:[self.filterPreferences[2] boolValue]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    PFUser *user = PFUser.currentUser;
    
    if(self.getAdvice){
        cell.textLabel.text = user.getAdviceInterests[indexPath.row];
    } else{
        cell.textLabel.text = user.giveAdviceInterests[indexPath.row];
    }
    return cell;
    
    NSLog(@"BYE!");
<<<<<<< HEAD

    
=======
    NSLog(@"Hello!");
>>>>>>> 27f13de5b009a380751106bed215da0b033dcb52
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PFUser *user = PFUser.currentUser;
    
    if(self.getAdvice){
        return user.getAdviceInterests.count;
    } else{
        return user.giveAdviceInterests.count;
    }
}
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    NSNumber *school = [NSNumber numberWithBool:NO];
    NSNumber *location = [NSNumber numberWithBool:NO];
    NSNumber *company = [NSNumber numberWithBool:NO];
    if([self.schoolSwitch isOn]){
        school = [NSNumber numberWithBool:YES];
    }
    if([self.locationSwitch isOn]){
        location = [NSNumber numberWithBool:YES];
    }
    if([self.companySwitch isOn]){
        company = [NSNumber numberWithBool:YES];
    }
    
    self.filterPreferences = [NSArray arrayWithObjects:school,company,location, nil];
    
    [self.delegate didChangeSchool:school withCompany:company andLocation:location];
    [self dismissViewControllerAnimated:YES completion:nil];
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
