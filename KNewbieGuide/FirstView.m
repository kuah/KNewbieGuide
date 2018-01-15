//
//  FirstView.m
//  KNewbieGuide
//
//  Created by 陈世翰 on 2018/1/15.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIButton *button = [[UIButton alloc]initWithFrame:(CGRect){100,100,50,50}];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _button = button;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    return self;
}
-(void)click:(id)sender{
    [KNewbieGuide playNext];
}

@end
