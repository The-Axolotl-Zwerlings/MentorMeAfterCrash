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
#import <TTGTextTagCollectionView.h>
#import "InterestModel.h"

@interface CustomTagData: NSObject
@property (nonatomic, strong) InterestModel *interestInfo;
@end

@implementation CustomTagData
- (NSString *)getInterestString {
    return _interestInfo.subject;
}
@end


@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource,TTGTextTagCollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *schoolSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *companySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *interestsSwitchs;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *getAdviceTTGView;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *giveAdviceTTGView;

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
        self.filterPreferences = [NSArray arrayWithObjects:@(0),@(0),@(0),@(0),nil];
    }
    
    
    
    
    self.giveAdviceTTGView.delegate = self;
    self.getAdviceTTGView.delegate = self;
    
    TTGTextTagConfig *config = self.giveAdviceTTGView.defaultConfig;
    
    
    config.tagTextFont = [UIFont boldSystemFontOfSize:18.0f];
    
    config.tagTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    
    config.tagBackgroundColor = [UIColor colorWithRed:0.98 green:0.91 blue:0.43 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    
    self.giveAdviceTTGView.horizontalSpacing = 6.0;
    self.giveAdviceTTGView.verticalSpacing = 8.0;
    
    config.tagBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBorderWidth = 1;
    config.tagSelectedBorderWidth = 1;
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 0.3);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 0.5f;
    
    config.tagCornerRadius = 7;
    
    for(InterestModel *interest in PFUser.currentUser.giveAdviceInterests){
        config = [TTGTextTagConfig new];
        config.extraData = interest;
        [_giveAdviceTTGView addTag:interest.subject withConfig:config];
    }
    for(InterestModel *interest in PFUser.currentUser.getAdviceInterests){
        config = [TTGTextTagConfig new];
        config.extraData = interest;
        [_getAdviceTTGView addTag:interest.subject withConfig:config];
    }
    
    self.getAdviceTTGView.defaultConfig = config;
    
    
    
    
    
    [self.schoolSwitch setOn:[self.filterPreferences[0] boolValue]];
    [self.companySwitch setOn:[self.filterPreferences[1] boolValue]];
    [self.locationSwitch setOn:[self.filterPreferences[2] boolValue]];
    [self.interestsSwitchs setOn:[self.filterPreferences[3] boolValue]];
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
    
    NSLog(@"BYE!");
    return cell;
    
    
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config{
    NSLog(@"you tapped %@", tagText);
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
    
    NSNumber *school = [NSNumber numberWithBool:[self.schoolSwitch isOn]];
    NSNumber *location = [NSNumber numberWithBool:[self.locationSwitch isOn]];
    NSNumber *company = [NSNumber numberWithBool:[self.companySwitch isOn]];
    NSNumber *interests = [NSNumber numberWithBool:[self.interestsSwitchs isOn]];
    
    self.filterPreferences = [NSArray arrayWithObjects:school,company,location,interests,nil];
    
    [self.delegate didChangeSchool:school withCompany:company withLocation:location andInterests:interests];
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
