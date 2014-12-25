//
//  DetailViewController.h
//  MyMovies
//
//  Created by taotao on 14/12/25.
//  Copyright (c) 2014年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESMovieDisplayViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

