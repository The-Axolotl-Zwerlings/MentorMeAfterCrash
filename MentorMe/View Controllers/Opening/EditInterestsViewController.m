//
//  EditInterestsViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/1/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "EditInterestsViewController.h"
#import "TLTagsControl.h"
#import "TLTagsControl+GetTypedString.h"
#import "Parse.h"
#import "InterestModel.h"
#import "AutocompleteTableViewCell.h"

@interface EditInterestsViewController () <UITableViewDelegate, UITableViewDataSource>
//Outlest for UI views
@property (weak, nonatomic) IBOutlet TLTagsControl *getAdviceField;
@property (weak, nonatomic) IBOutlet TLTagsControl *giveAdviceField;
@property (weak, nonatomic) IBOutlet UIButton *saveChangesButton;

@property (strong, nonatomic) IBOutlet UITableView *interestsTableView;

@property (strong, nonatomic) NSString* store;
@property (nonatomic, strong) NSArray* getAdviceInterests;
@property (nonatomic, strong) NSArray* giveAdviceInterests;
@property (strong, nonatomic) NSArray* forTableView;

@end

@implementation EditInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_getAdviceField inputValues];
    
    // Do any additional setup after loading the view.
    _getAdviceField.mode = TLTagsControlModeEdit;
    _getAdviceField.tagPlaceholder = @"Type a topic";
    [_getAdviceField reloadTagSubviews];
    
    _giveAdviceField.mode = TLTagsControlModeEdit;
    _giveAdviceField.tagPlaceholder = @"Type a topic";
    [_giveAdviceField reloadTagSubviews];
    
    self.interestsTableView.delegate = self;
    self.interestsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passString:(NSString *)string{
    self.store = string;
    [self searchAutocompleteEntriesWithSubstring:string];
    CGRect intermediate = [self.getAdviceField frame];
    CGRect tablePosition;
    tablePosition.size.width = intermediate.size.width;
    tablePosition.size.height = 90;
    tablePosition.origin.x = intermediate.origin.x;
    tablePosition.origin.y = intermediate.origin.y + 95;
    self.interestsTableView.frame = tablePosition;
    [self.view addSubview:self.interestsTableView];
    //NSLog(@"here it is %@" , self.store);
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    PFQuery *query = [PFQuery queryWithClassName:@"InterestModel"];
    [query whereKey:@"subject" hasPrefix:substring];
    [query findObjectsInBackgroundWithBlock:^(NSArray *subjects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", subjects.count);
            NSMutableArray* temporary = [[NSMutableArray alloc]init];
            for (InterestModel *interest in subjects) {
                if(substring == interest.subject){
                    [self.interestsTableView removeFromSuperview];
                }
                else{
                    [temporary addObject:interest.subject];
                }
            }
            self.forTableView = [[NSArray alloc]initWithArray:temporary];
            [self.interestsTableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//TABLEVIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.forTableView == nil || self.forTableView.count == 0){
        return 1;
    }
    else{
        NSLog(@"%lu", self.forTableView.count);
        return (self.forTableView.count);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AutocompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestCell" forIndexPath:indexPath];
    cell.makeInterestButton.hidden = YES;
    
    if(self.forTableView == nil || self.forTableView.count == 0){
        NSLog(@"IN IF1");
        cell.makeInterestButton.hidden = NO;
        cell.interestLabel.hidden = YES;
        return cell;
    }
    else{
        NSLog(@"IN ELSE1");
        cell.makeInterestButton.hidden = YES;
        cell.interestLabel.text = self.forTableView [indexPath.row];
        cell.interestLabel.hidden = NO;
        return cell;
    }
}

- (IBAction)makeNewInterest:(id)sender {
    PFObject* newInterest = [PFObject objectWithClassName:@"InterestModel"];
    if (self.store != nil){
        newInterest[@"subject"] = self.store;
        
        [newInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"New interest saved!");
                NSString* typed = self.store;
                [self searchAutocompleteEntriesWithSubstring:typed];
            }
            else {
                NSLog(@"Error: %@", error.description);
            }
        }];
}
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath     *)indexPath
{
    AutocompleteTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.store != nil){
        //self.getAdviceField.text = cell.interestLabel.text;
        //make label equal to store
        [self.getAdviceField addTag:cell.interestLabel.text];
        [self.interestsTableView removeFromSuperview];
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
