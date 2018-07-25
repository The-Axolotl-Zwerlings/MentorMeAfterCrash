//
//  ReviewViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;

@end

@implementation ReviewViewController

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
    // Do any additional setup after loading the view.
    self.ratingView.notSelectedImage = [UIImage imageNamed:@"star-empty.png"];
    self.ratingView.halfSelectedImage = [UIImage imageNamed:@"star-half.png"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"star-full.png"];
    self.ratingView.rating = 0;
    self.ratingView.editable = YES;
    self.ratingView.maxRating = 5;
    self.ratingView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 400);
    
}


// Add to bottom
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    self.starLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tappedOutsdie:(UITapGestureRecognizer *)sender {
    [self.commentsTextView resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGPoint offset = self.scrollView.contentOffset;
    offset.y -= 280; // You can change this, but 200 doesn't create any problems
    [self.scrollView setContentOffset:offset];
    [UIView commitAnimations];
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
