//
//  OverlayView.m
//  VoiceMemoTableView
//
//  Created by Muhammad Zeeshan on 01/02/2016.
//  Copyright © 2016 Muhammad Zeeshan. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.selectedCellRect, point) && self.superview) {
        return nil;
    }
    return hitView;
}

@end
