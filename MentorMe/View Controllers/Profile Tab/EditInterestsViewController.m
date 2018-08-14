//
//  EditInterestsViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/1/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "EditInterestsViewController.h"
#import "TLTagsControl.h"
#import "Parse.h"
#import "InterestModel.h"
#import "AutocompleteTableViewCell.h"
#import "PFUser+ExtendedUser.h"
#import "ProfileViewController.h"

@interface EditInterestsViewController () <UITableViewDelegate, UITableViewDataSource, TLDataHandler>
//Outlets for UI views
@property (weak, nonatomic) IBOutlet TLTagsControl *getAdviceField;
@property (weak, nonatomic) IBOutlet TLTagsControl *giveAdviceField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *interestsTableView;
@property (strong, nonatomic) NSString* store;
@property (strong, nonatomic) NSString* getStore;
@property (strong, nonatomic) NSString* giveStore;
@property (nonatomic, strong) NSMutableArray* getAdviceInterests;
@property (nonatomic, strong) NSMutableArray* giveAdviceInterests;
@property (strong, nonatomic) NSArray* forTableView;
@property (strong, nonatomic) NSArray* interestsToCreate;
@property (strong, nonatomic) NSArray* creationArray;
@property (nonatomic, strong) NSArray* array1;
@property (nonatomic, strong) NSArray* array2;
@property (nonatomic, strong) NSString* myInterest;
@property (nonatomic, strong) TLTagsControl *currentTagControll;
@property (nonatomic, assign) NSInteger additionalCell;

@end

@implementation EditInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveButton.layer.borderColor = UIColor.blueColor.CGColor;
    self.saveButton.layer.borderWidth = 2;
    
    for(InterestModel* mod in self.array1){
        [self.getAdviceField addTag:mod.subject];
    }
    for(InterestModel* mod in self.array2){
        [self.giveAdviceField addTag:mod.subject];
    }
    //setting all delegates to self
    self.getAdviceField.dataHandler = self;
    self.giveAdviceField.dataHandler = self;
    self.interestsTableView.delegate = self;
    self.interestsTableView.dataSource = self;
    
    // Do any additional setup after loading the view.
    _getAdviceField.mode = TLTagsControlModeEdit;
    _getAdviceField.tagPlaceholder = @"Type a topic";
    [_getAdviceField reloadTagSubviews];
    
    _giveAdviceField.mode = TLTagsControlModeEdit;
    _giveAdviceField.tagPlaceholder = @"Type a topic";
    [_giveAdviceField reloadTagSubviews];
    
    //UI things
    self.giveAdviceField.layer.cornerRadius = 5;
    self.giveAdviceField.layer.masksToBounds = true;
    self.getAdviceField.layer.cornerRadius = 5;
    self.getAdviceField.layer.masksToBounds = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addString:(TLTagsControl *)tagControl withString:(NSString *)typed{
    self.myInterest = typed;
    if(tagControl == self.getAdviceField){
        self.currentTagControll = self.getAdviceField;
        self.myInterest = typed;
        if (typed.length >= 1){
            self.store = typed;
            self.getStore = typed;
            NSLog(@"succesfully obtained string");
            CGRect intermediate = [self.getAdviceField frame];
            CGRect tablePosition;
            tablePosition.size.width = intermediate.size.width;
            tablePosition.size.height = 80;
            tablePosition.origin.x = intermediate.origin.x;
            tablePosition.origin.y = intermediate.origin.y + 48;
            self.interestsTableView.frame = tablePosition;
            [self.interestsTableView.layer setCornerRadius:4];
            [self.interestsTableView.layer setMasksToBounds:YES];
            [self.view addSubview:self.interestsTableView];
            [self searchAutocompleteEntriesWithSubstring:typed];
        }
        else{
            [self.interestsTableView removeFromSuperview];
        }
    }
    if(tagControl == self.giveAdviceField){
        self.currentTagControll = self.giveAdviceField;
        if (typed.length >= 1){
            self.store = typed;
            self.giveStore = typed;
            NSLog(@"succesfully obtained string");
            CGRect intermediate = [self.giveAdviceField frame];
            CGRect tablePosition;
            tablePosition.size.width = intermediate.size.width;
            tablePosition.size.height = 80;
            tablePosition.origin.x = intermediate.origin.x;
            tablePosition.origin.y = intermediate.origin.y + 48;
            self.interestsTableView.frame = tablePosition;
            [self.interestsTableView.layer setCornerRadius:4];
            [self.interestsTableView.layer setMasksToBounds:YES];
            [self.view addSubview:self.interestsTableView];
            [self searchAutocompleteEntriesWithSubstring:typed];
        }
        else{
            [self.interestsTableView removeFromSuperview];
        }
    }
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    PFQuery *query = [PFQuery queryWithClassName:@"InterestModel"];
    [query whereKey:@"subject" hasPrefix:substring];
    [query findObjectsInBackgroundWithBlock:^(NSArray *subjects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu scores.", subjects.count);
            NSMutableArray* temporary = [[NSMutableArray alloc]init];
            for (InterestModel *interest in subjects) {
                if([substring isEqualToString:interest.subject]){
                    self.additionalCell =0;
                }
                else{
                    self.additionalCell =1;
                }
                    [temporary addObject:interest.subject];
                if  (temporary.count == 0)
                    self.myInterest = substring;
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
        return (self.forTableView.count) + self.additionalCell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AutocompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestCell" forIndexPath:indexPath];
    [cell.contentView.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1].CGColor];
    [cell.contentView.layer setBorderWidth:1];
//    UIColor *tagBackgrounColor = [UIColor colorWithRed:0.13
//                                                                                                      green:0.70
//                                                                                                       blue:0.67
//                                                                                                      alpha:1];
//    cell.contentView.backgroundColor = tagBackgrounColor;
    if(self.forTableView == nil || self.forTableView.count == 0){
        NSLog(@"IN IF1");
        cell.interestLabel.hidden = YES;
        cell.createNewInterest.hidden = NO;
        return cell;
    }
    else{
        if(self.additionalCell == 0){
            cell.interestLabel.text = self.forTableView [indexPath.row];
            cell.interestLabel.textColor = UIColor.blackColor;
            cell.interestLabel.hidden = NO;
            cell.createNewInterest.hidden = YES;
        }
     
       else if (self.additionalCell == 1){
            if(indexPath.row <= self.forTableView.count - 1){
            cell.interestLabel.text = self.forTableView [indexPath.row];
            cell.interestLabel.textColor = UIColor.blackColor;
            cell.interestLabel.hidden = NO;
            cell.createNewInterest.hidden = YES;
            }
            if (indexPath.row == self.forTableView.count){
            cell.interestLabel.hidden = YES;
            cell.createNewInterest.hidden = NO;
            }
        }
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    AutocompleteTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.currentTagControll == self.getAdviceField){
        [self.getAdviceField addTag:cell.interestLabel.text];
        [self.interestsTableView removeFromSuperview];
        [self.getAdviceField emptyField];
        self.getStore = nil;
    }
    if (self.currentTagControll == self.giveAdviceField){
        [self.giveAdviceField addTag:cell.interestLabel.text];
        [self.interestsTableView removeFromSuperview];
        [self.giveAdviceField emptyField];
        self.giveStore = nil;
    }
}

- (IBAction)onTapCancel:(id)sender{
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapSave:(id)sender {
    self.getAdviceInterests = [[NSMutableArray alloc]init];
    self.giveAdviceInterests = [[NSMutableArray alloc]init];
    for(NSString* tag in self.getAdviceField.tags){
        InterestModel* newInterest = [[InterestModel alloc]init];
        newInterest.subject = tag;
        [self.getAdviceInterests addObject:newInterest];
        NSLog(@"%@" , tag);
    }
    for(NSString* tag in self.giveAdviceField.tags){
        InterestModel* newInterest = [[InterestModel alloc]init];
        newInterest.subject = tag;
        [self.giveAdviceInterests addObject:newInterest];
    }
    PFUser *currUser = [PFUser currentUser];
    currUser.getAdviceInterests = [NSArray arrayWithArray:self.getAdviceInterests];
    currUser.giveAdviceInterests = [NSArray arrayWithArray:self.giveAdviceInterests];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Interest added to user");
            [self resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}
- (IBAction)atTapCreateNew:(id)sender {
    [InterestModel addInterest:self.myInterest inCategory:@"new Interest"];
    [self.interestsTableView removeFromSuperview];
    if (self.currentTagControll == self.getAdviceField){
        [self.getAdviceField addTag:self.myInterest];
        [self.getAdviceField emptyField];
    }
    
    else if (self.currentTagControll == self.giveAdviceField){
        [self.giveAdviceField addTag:self.myInterest];
        [self.giveAdviceField emptyField];
    }
}

-(void)update:(NSArray*)one and:(NSArray*)two{
    self.array1 = [[NSArray alloc]initWithArray:one];
    self.array2 = [[NSArray alloc]initWithArray:two];
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
