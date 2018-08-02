//
//  TLTagsControl+GetTypedString.m
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/1/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "TLTagsControl+GetTypedString.h"
#import "EditInterestsViewController.h"
@implementation TLTagsControl (GetTypedString)

-(void)inputValues{
    
    [self.tagInputField_  addTarget:self action:@selector(valueChangedMethodcall:) forControlEvents:UIControlEventAllEditingEvents];
}
- (IBAction)valueChangedMethodcall:(UITextField *)sender {
    if (self.tagInputField_.text.length >= 3){
        EditInterestsViewController *hereItIs = [[EditInterestsViewController alloc]init];
        [hereItIs passString:self.tagInputField_.text];
       
    }
}
@end
