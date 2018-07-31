//
//  ReviewViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ReviewViewController.h"
#import "Review.h"
@interface ReviewViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UILabel *reviewForLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSArray *complimentsArray;
/*Compliments Array
 0 - Great Convo
 1 - Down to Earth
 2 - Useful Advice
 3 - Friendly
 4 - Super Knowledgeable
*/

@end

@implementation ReviewViewController

- (IBAction)touch1:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (IBAction)touch2:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}
- (IBAction)touch3:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}
- (IBAction)touch4:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}
- (IBAction)touch5:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += 280; // You can change this, but 200 doesn't create any problems
    [self.scrollView setContentOffset:offset];
    [UIView commitAnimations];
}


- (void)viewDidLoad {
    
    self.commentsTextView.delegate = self;
    [super viewDidLoad];
    
    self.reviewForLabel.text = [@"Review for " stringByAppendingString:self.reviewee.name];
    
    
    // Stuff relating to star rating view
    self.ratingView.notSelectedImage = [UIImage imageNamed:@"star-empty.png"];
    self.ratingView.halfSelectedImage = [UIImage imageNamed:@"star-half.png"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"star-full.png"];
    self.ratingView.rating = 0;
    self.ratingView.editable = YES;
    self.ratingView.maxRating = 5;
    self.ratingView.delegate = self;
    
    self.doneButton.layer.cornerRadius = 4;
    
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 400);
    
}

- (IBAction)doneAction:(UIButton *)sender {
    NSMutableArray *mutableCompliments = [[NSMutableArray alloc]init];
    [mutableCompliments addObject:[NSNumber numberWithBool:self.greatConvoButton.isSelected]];
    [mutableCompliments addObject:[NSNumber numberWithBool:self.downToEarthButton.isSelected]];
    [mutableCompliments addObject:[NSNumber numberWithBool:self.usefulAdviceButton.isSelected]];
    [mutableCompliments addObject:[NSNumber numberWithBool:self.friendlyButton.isSelected]];
    [mutableCompliments addObject:[NSNumber numberWithBool:self.superKnowledgeButton.isSelected]];
    self.complimentsArray = [NSArray arrayWithArray:mutableCompliments];
    
    
    
                                 
    [Review postReview:self.reviewee withRating:[NSNumber numberWithFloat:self.ratingView.rating] andComplimentsArray:self.complimentsArray];
    
    
}

// Add to bottom
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    NSString* formattedNumber = [NSString stringWithFormat:@"%.f", rating];
    self.starLabel.text = [NSString stringWithFormat:@"Rating: %@ stars", formattedNumber];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tappedOutsdie:(UITapGestureRecognizer *)sender {
    if([self.commentsTextView isFirstResponder]){
        [self.commentsTextView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        CGPoint offset = self.scrollView.contentOffset;
        offset.y -= 280; // You can change this, but 200 doesn't create any problems
        [self.scrollView setContentOffset:offset];
        [UIView commitAnimations];
    }
}
- (IBAction)cancelButton:(UIButton *)sender {
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
