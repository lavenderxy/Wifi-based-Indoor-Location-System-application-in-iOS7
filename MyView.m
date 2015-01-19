//
//  MyView.m
//  wifi_4
//
//  Created by 闫 欣宇 on 14-5-15.
//  Copyright (c) 2014年 闫 欣宇. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint (context, 0, 0);
    CGContextAddLineToPoint (context, 100, 150);
//    CGContextAddLineToPoint (context, 160, 150);
    
    CGContextStrokePath(context);
    

    
    
}

@end
