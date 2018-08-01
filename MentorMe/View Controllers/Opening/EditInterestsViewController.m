//
//  EditInterestsViewController.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/1/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "EditInterestsViewController.h"
#import "TLTagsControl.h"

@interface EditInterestsViewController () 
//Outlest for UI views
@property (weak, nonatomic) IBOutlet TLTagsControl *getAdviceField;
@property (weak, nonatomic) IBOutlet TLTagsControl *giveAdviceField;
@property (weak, nonatomic) IBOutlet UIButton *saveChangesButton;

@end

@implementation EditInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _getAdviceField.mode = TLTagsControlModeEdit;
    _getAdviceField.tagPlaceholder = @"Type a topic";
    [_getAdviceField reloadTagSubviews];
    
    _giveAdviceField.mode = TLTagsControlModeEdit;
    _giveAdviceField.tagPlaceholder = @"Type a topic";
    [_giveAdviceField reloadTagSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
