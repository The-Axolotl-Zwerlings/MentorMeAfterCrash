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
@property (strong, nonatomic) NSArray *filterPreferences;
//school, company, location

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interestsTableView.delegate = self;
    self.interestsTableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem"];
    PFUser *user = PFUser.currentUser;
    
    if([self.giveOrGet isEqualToString:@"Give"]){
        cell.textLabel.text = user.giveAdviceInterests[indexPath.row];
    } else{
        cell.textLabel.text = user.getAdviceInterests[indexPath.row];
    }
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    PFUser *user = PFUser.currentUser;
    
    if([self.giveOrGet isEqualToString:@"Give"]){
        return user.giveAdviceInterests.count;
    } else{
        return user.getAdviceInterests.count;
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
