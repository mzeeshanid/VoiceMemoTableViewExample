//
//  ViewController.m
//  VoiceMemoTableView
//
//  Created by Muhammad Zeeshan on 29/01/2016.
//  Copyright © 2016 Muhammad Zeeshan. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "OverlayView.h"

@interface ViewController ()
{
    // 1
    NSMutableArray *records;
    
    // 2
    NSIndexPath *openedIndexPath;
    
    // 3
    OverlayView *overlayView;
    
    // 4
    CAShapeLayer *overlayViewLayer;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self setUpOverlayView];
    
    // 5
    records = [NSMutableArray arrayWithObjects:@"BSCS Lecture 1",
               @"MBA Lecture 4",
               @"BBA Lecture 9",
               @"MA Lecture 2",
               @"MSCS Lecture 6",
               @"MSSE Lecture 8",
               @"LLB Lecture 10",
               @"B.COM Lecture 12",
               @"M.COM Lecture 15",
               @"BA Lecture 7",
               @"BE Lecture 16",
               @"ME Lecture 18",
               nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Methods -
// 6
- (void)setUpOverlayView {
    overlayView = [[OverlayView alloc] initWithFrame:self.view.bounds];
    [overlayView setBackgroundColor:[UIColor lightGrayColor]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [overlayView addGestureRecognizer:tapGestureRecognizer];
    
    overlayViewLayer = [CAShapeLayer layer];
    [overlayViewLayer setFrame:overlayView.bounds];
    [overlayViewLayer setMasksToBounds:YES];
}
// 7
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapgesture {
    
    NSIndexPath *selectedIndexPath = openedIndexPath;
    openedIndexPath = nil;
    [self.myTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView animateWithDuration:0.3 animations:^{
        [overlayView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
    }];
}
#pragma mark - UITableView Delegates and Datasource -
// 8
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(openedIndexPath) {
        CGRect rect = overlayView.bounds;
        rect.origin.y = scrollView.contentOffset.y;
        [overlayView setFrame:rect];
        
        MyTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:openedIndexPath];
        
        if(cell) {
            CGRect cellRect = [overlayView convertRect:cell.frame fromView:self.myTableView];
            [overlayView setSelectedCellRect:cellRect];
            
            CGRect topRect = CGRectMake(0, 0, cellRect.size.width, cellRect.origin.y);
            CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(cellRect), cellRect.size.width, overlayView.frame.size.height - CGRectGetMaxY(cellRect));
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:topRect];
            UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:bottomRect];
            [path appendPath:bottomPath];
            
            [overlayViewLayer setPath:path.CGPath];
            [overlayView.layer setMask:overlayViewLayer];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([openedIndexPath isEqual:indexPath]) {
        return 88.0;
    } else {
        return 46.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return records.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MyTableViewCell";
    MyTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = records[indexPath.row];
    [cell.title setText:title];
    
    return cell;
    
}
// 9
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    openedIndexPath = indexPath;
    [tableView reloadRowsAtIndexPaths:@[openedIndexPath] withRowAnimation:UITableViewRowAnimationFade];

    [overlayView setAlpha:0.0f];
    [tableView addSubview:overlayView];
    
    [self scrollViewDidScroll:tableView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [overlayView setAlpha:0.7];
    }];
}
@end
