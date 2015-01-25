//
//  RESWeatherAnimationViewController.m
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESWeatherAnimationViewController.h"
#import "AFNetworking.h"
#import "NSDictionary+weather.h"

@interface RESWeatherAnimationViewController ()
@property (nonatomic,strong)NSTimer *generator;
@end

@implementation RESWeatherAnimationViewController

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *desc = [self.weatherDictionary weatherDescription];
    if ((self.weatherDictionary)[@"tempMinC"])
    {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@ \u00B0c - %@ \u00B0c",[self.weatherDictionary tempMinC],[self.weatherDictionary tempMaxC]];
        
    }
    else
    {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@ \u00B0c",[self.weatherDictionary tempC]];
    }
    self.title = desc;
    [self start:desc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -
#pragma mark backGround Image
-(IBAction)updateBackgroundImage:(id)sender
{
    //1
    NSURL *url = [NSURL URLWithString:@"http://www.raywenderlich.com/wp-content/uploads/2014/01/sunny-background.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    //3
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //4
        self.backgroundImageView.image = responseObject;
        [self saveImage:responseObject withFileName:@"background.png"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //5
        NSLog(@"Error:%@",[error localizedDescription]);
        
    }];
    
    //6
    [operation start];
    
}

-(void)saveImage:(UIImage *)image withFileName:(NSString *)fileName
{
    
    //1
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"weatherHTTPClientImages/"];
    
    //2
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir])
    {
        if (!isDir)
        {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    
    //3
    path = [path stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSLog(@"Written: %d",[imageData writeToFile:path atomically:YES]);
    
}

-(UIImage *)imageWithFileName:(NSString *)fileName
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    path = [paths[0] stringByAppendingPathComponent:@"WeatherHTTPClientImages"];
    path = [path stringByAppendingPathComponent:fileName];
    
    return [UIImage imageWithContentsOfFile:path];
}


-(IBAction)deleteBackgroundImage:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"WeatherHTTPClientImages/"];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    NSString *desc = [self.weatherDictionary weatherDescription];
    [self start:desc];
}


#pragma mark - 
#pragma mark Animation
-(void)start:(NSString *)type
{
    [self stop];
    
    if([[type lowercaseString] isEqualToString:@"clear"]) {
        [self clear];
    }
    else if([[type lowercaseString] isEqualToString:@"cloudy"] ||
            [[type lowercaseString] isEqualToString:@"overcast"]) {
        UIImageView *iv = [self cloudy];
        [self pulseImageView:iv];
    }
    else if([[type lowercaseString] isEqualToString:@"partly cloudy"]) {
        UIImageView *iv = [self sunny:CGPointMake(100,50)];
        [self bounceImageView:iv];
        [self cloudy];
    }
    else if([[type lowercaseString] isEqualToString:@"sunny"]) {
        UIImageView *iv = [self sunny:CGPointMake(160,90)];
        [self pulseImageView:iv];
    }
    else if([[type lowercaseString] isEqualToString:@"light rain shower"] ||
            [[type lowercaseString] isEqualToString:@"patchy rain nearby"] ||
            [[type lowercaseString] isEqualToString:@"patchy light drizzle"] ||
            [[type lowercaseString] isEqualToString:@"moderate or heavy rain in area with thunder"] ||
            [[type lowercaseString] isEqualToString:@"patchy light rain"]) {
        
        [self weatherItem:@"rain" andLevel:1.0];
        [self raining];
    }
    else if([[type lowercaseString] isEqualToString:@"mist"]) {
        [self cloudy];
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.center = CGPointMake(160,125);
        [view setBackgroundColor:[UIColor whiteColor]];
        view.alpha = 0.5;
        [self.backgroundImageView addSubview:view];
        [self.backgroundImageView bringSubviewToFront:view];
    }
    else if([[type lowercaseString] isEqualToString:@"light snow"] ||
            [[type lowercaseString] isEqualToString:@"patchy light snow"]) {
        [self weatherItem:@"snow" andLevel:.5];
        [self andryCloud];
    }
    else if([[type lowercaseString] isEqualToString:@"moderate snow"] ||
            [[type lowercaseString] isEqualToString:@"moderate or heavy sleet"] ||
            [[type lowercaseString] isEqualToString:@"patchy moderate snow"]) {
        [self weatherItem:@"snow" andLevel:2.0];
        [self andryCloud];
    }
    else if([[type lowercaseString] isEqualToString:@"heavy snow"]||
            [[type lowercaseString] isEqualToString:@"patchy heavy snow"]) {
        [self weatherItem:@"snow" andLevel:3.5];
        [self andryCloud];
    }
    else {
        [self weatherItem:@"rain" andLevel:1.0];
        [self raining];
    }
    
    self.backgroundImageView.image = [UIImage imageNamed:@"lightsky.png"];
}


- (UIImageView *)cloudy
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud"]];
    imageView.center = CGPointMake(160,125);
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView bringSubviewToFront:imageView];
    return imageView;
}

- (void)pulseImageView:(UIImageView *)iv
{
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         iv.transform = CGAffineTransformScale(iv.transform, 2, 2);
                     }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                iv.transform = CGAffineTransformScale(iv.transform, .5, .5);
                                    }
                         completion:^(BOOL finished) {
                             if(finished){
                            [self pulseImageView:iv];
                             }
                             }];

                     }];
    
}


- (UIImageView *)sunny:(CGPoint)point
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun"]];
    imageView.center = point;
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView bringSubviewToFront:imageView];
    
    return imageView;
    
}

- (void)bounceImageView:(UIImageView *)imageView
{
    CGPoint point = imageView.center;
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        imageView.center = CGPointMake(point.x, point.y+75);
    }
                     completion:^(BOOL finished) {
                         
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            imageView.center = CGPointMake(imageView.center.x, imageView.center.y-75);
        } completion:^(BOOL finished) {
            if (finished){
                [self bounceImageView:imageView];
            }
        }];
                         
    }];
    

}

-(void)raining
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angrycloud"]];
    imageView.center = CGPointMake(160,125);
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView bringSubviewToFront:imageView];
}

-(void)weatherItem:(NSString *)name andLevel:(CGFloat)level
{
    if (self.generator) {
        [self.generator invalidate];
        self.generator = nil;
    }
    self.generator = [NSTimer scheduledTimerWithTimeInterval:(.1*(1/level)) target:self selector:@selector(addItem:) userInfo:name repeats:YES];
}

-(void)addItem:(NSTimer *)timer
{
    NSString *image = timer.userInfo;
    int x = arc4random()%80;
    int y = arc4random()%100;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imageView.center = CGPointMake(x+120, y+120);
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView sendSubviewToBack:imageView];
    [self tweenLeftImageView:imageView];
}

-(void)tweenLeftImageView:(UIImageView *)imageView
{
    CGPoint point = imageView.center;
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        imageView.center = CGPointMake(point.x-50, point.y+200);
        imageView.alpha=0;
    }
                     completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


- (void)andryCloud
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angrycloud"]];
    imageView.center = CGPointMake(160,125);
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView bringSubviewToFront:imageView];
}

- (void)thunder
{
    UIImageView *thunderBoltImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thunderbolt"]];
    thunderBoltImageView.center = CGPointMake(160,150);
    [self.backgroundImageView addSubview:thunderBoltImageView];
    [self.backgroundImageView bringSubviewToFront:thunderBoltImageView];
}

-(void)clear
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clear"]];
    imageView.center = CGPointMake(160, 125);
    [self.backgroundImageView addSubview:imageView];
    [self.backgroundImageView bringSubviewToFront:imageView];
    [self rotateImageView:imageView];
}

-(void)rotateImageView:(UIImageView *)imageView
{
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI/2);
    }
                     completion:^(BOOL finished) {
        if (finished) {
            [self rotateImageView:imageView];
        }
    }];
    
}

-(void)stop
{
    [self.generator invalidate];
    self.generator = nil;
    for (UIView *view in self.backgroundImageView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
