//
//  SecondView.m
//  KNewbieGuide
//
//  Created by 陈世翰 on 2018/1/15.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "SecondView.h"

@implementation SecondView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIButton *button = [[UIButton alloc]initWithFrame:(CGRect){100,100,50,50}];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _button = button;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    return self;
}
-(void)click:(id)sender{
    [KNewbieGuide playNext];
}

@end
