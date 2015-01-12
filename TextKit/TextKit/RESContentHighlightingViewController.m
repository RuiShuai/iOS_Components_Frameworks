//
//  RESContentHighlightingViewController.m
//  TextKit
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESContentHighlightingViewController.h"
#import "RESDynamicTextStorage.h"

@interface RESContentHighlightingViewController ()

@end

@implementation RESContentHighlightingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSTextStorage
    RESDynamicTextStorage *textStorage = [[RESDynamicTextStorage alloc] init];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    
    CGRect textViewRect = CGRectInset(self.view.bounds, 10.0, 20.0);
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(textViewRect.size.width, CGFLOAT_MAX)];//initWithSize:textViewRect.size];//
    
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [textStorage addLayoutManager:layoutManager];
    
    //UITextView
    NSString *contentOfTextView = self.textView.text;
    
    //移除old view
    [self.textView removeFromSuperview];

    self.textView = [[UITextView alloc]initWithFrame:textViewRect textContainer:container];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.scrollEnabled = YES;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.textView.selectable = YES;
    //添加new view
    [self.view addSubview:self.textView];
    
    textStorage.tokens = @{
                           @"润土":@{NSForegroundColorAttributeName:[UIColor redColor]},
                           @"股市":@{NSForegroundColorAttributeName:[UIColor blueColor]},
                           @"银行":@{NSUnderlineStyleAttributeName:@1},
                           @"实体":@{NSBackgroundColorAttributeName:[UIColor yellowColor]},
                           @"网络":@{NSFontAttributeName:[UIFont fontWithName:@"Chalkduster" size:14.0f]},
                           @"老虎" : @{ NSFontAttributeName : [UIFont fontWithName:@"Palatino-Bold" size:14.0f], NSForegroundColorAttributeName : [UIColor purpleColor], NSUnderlineStyleAttributeName : @1},
                           @"俄罗斯" : @{ NSFontAttributeName : [UIFont fontWithName:@"Chalkduster" size:14.0f],NSForegroundColorAttributeName : [UIColor purpleColor] },
                           defaultTokenName:@{
                                   NSForegroundColorAttributeName : [UIColor blackColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                   NSUnderlineStyleAttributeName : @0,
                                   NSBackgroundColorAttributeName : [UIColor whiteColor],
                                   NSStrikethroughStyleAttributeName : @0,
                                   NSStrokeWidthAttributeName : @0}};

    //动态字体
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self.textView setText:contentOfTextView];
    
}

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
