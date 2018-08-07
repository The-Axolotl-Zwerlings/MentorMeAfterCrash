//
//  ReviewViewController.m
//  MentorMe
//
//  Created by Taylor Murray on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "ReviewViewController.h"
#import "Review.h"
#import "ReviewDataDelegate.h"
#import "ComplimentsCell.h"
@interface ReviewViewController () <UITextViewDelegate, AddCompliment>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UICollectionView *complimentsCollectionView;
@property (strong, nonatomic) id<UICollectionViewDataSource> dataSource;
@property (strong, nonatomic) id<UICollectionViewDelegate> delegate;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];

    self.navigationItem.title = @"Review";
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
    
    
    ReviewDataDelegate *reviewDataDelegate = [[ReviewDataDelegate alloc]initWithOrigin:self];
    
    self.delegate = reviewDataDelegate;
    self.dataSource = reviewDataDelegate;
    self.complimentsCollectionView.dataSource = self.dataSource;
    self.complimentsCollectionView.delegate = self.delegate;
    
    self.complimentsArray = [NSArray arrayWithObjects:@(0),@(0),@(0),@(0),@(0),nil];
}

-(void)doneAction{
                                 
    [Review postReview:self.reviewee withRating:[NSNumber numberWithFloat:self.ratingView.rating] andComplimentsArray:self.complimentsArray];
    [self.navigationController popViewControllerAnimated:YES];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeCompliment:(NSNumber *)index andSelectedStatus:(NSNumber *)selected{
    NSMutableArray *complimentMutable = [NSMutableArray arrayWithArray:self.complimentsArray];
    [complimentMutable replaceObjectAtIndex:[index integerValue] withObject:selected];
    self.complimentsArray = complimentMutable;
}


@end
