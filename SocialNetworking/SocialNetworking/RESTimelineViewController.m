//
//  RESTimelineViewController.m
//  SocialNetworking
//
//  Created by taotao on 15/1/16.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESTimelineViewController.h"

@interface RESTimelineViewController ()

@end

@implementation RESTimelineViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timelineData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    BOOL facebook = NO;
    NSDictionary *timelineObj = [self.timelineData objectAtIndex:indexPath.row];
    if ([timelineObj objectForKey:@"privacy"] != nil) {
        facebook = YES;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (facebook) {
        
        NSString *textToDisplay = nil;
        if ([timelineObj objectForKey:@"message"]!=nil) {
            textToDisplay = [timelineObj objectForKey:@"message"];
        }else if ([timelineObj objectForKey:@"story"]!=nil){
            textToDisplay = [timelineObj objectForKey:@"story"];
        }else if ([timelineObj objectForKey:@"description"]!=nil){
            textToDisplay = [timelineObj objectForKey:@"description"];
        }else{
            textToDisplay = @"Unable to determine a text message to display";
        }
        
        cell.textLabel.text = textToDisplay;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSString *URLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[[timelineObj objectForKey:@"from"] objectForKey:@"id"]];
            
            if (URLString != nil) {
                NSURL *url = [[NSURL alloc]initWithString:URLString];
                NSData *imageData = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image= [[UIImage alloc]initWithData: imageData];
                
                //update UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
                
            }
            
            
        });
        
    //not facebook
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSString *URLString = [[timelineObj objectForKey:@"user"] objectForKey:@"profile_image_url"];
            
            if (URLString != nil) {
                NSURL *url = [[NSURL alloc]initWithString:URLString];
                NSData *imageData = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc]initWithData:imageData];
                
                //update UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
                
            }
            
        });
        
        cell.textLabel.text = [timelineObj objectForKey:@"text"];
        
    }
    
    return cell;
}




- (IBAction)dismissTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
