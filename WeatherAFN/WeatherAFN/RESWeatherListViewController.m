//
//  RESWeatherListViewController.m
//  WeatherAFN
//
//  Created by taotao on 15/1/24.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESWeatherListViewController.h"
#import "RESWeatherAnimationViewController.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "UIImageView+AFNetworking.h"

static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";

@interface RESWeatherListViewController ()

@property(strong)NSDictionary *weather;
@property(strong,nonatomic) CLLocation *location;

@property(strong,nonatomic) NSMutableDictionary *currentDictionary;
@property(nonatomic,strong) NSMutableDictionary *xmlWeather;
@property(nonatomic,strong) NSString *elementName;
@property(nonatomic,strong) NSMutableString *outString;

@end

@implementation RESWeatherListViewController

#pragma mark -
#pragma mark View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 
#pragma mark weather api
- (IBAction)apiTapped:(id)sender
{

    RESLocationManager *appLocationManager = [RESLocationManager sharedLocationManager];
    [appLocationManager getLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        NSLog(@"%f,%f",location.coordinate.latitude,location.coordinate.longitude);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"locationUpdated" object:nil];
        
        
        //invoke on mainThread
        [self performSelectorOnMainThread:@selector(updateWeatherWithLocation:) withObject:location waitUntilDone:NO];
        
    }];

    
}


-(void)locationUpdated:(CLLocation *)location
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)updateWeatherWithLocation:(CLLocation *)location
{
    //weather http client
    RESWeatherHTTPClient *client = [RESWeatherHTTPClient sharedWeatherHTTPClient];
    client.delegate = self;
    [client updateWeatherAtLocation:location forNumberOfDays:5];
}


#pragma mark RESWeatherHTTPClient delegate
-(void)weatherHTTPClient:(RESWeatherHTTPClient *)client didUpdateWithWeather:(id)weather
{
    self.weather = weather;
    self.title = @"API Updated";
    [self.tableView reloadData];
}

-(void)weatherHTTPClient:(RESWeatherHTTPClient *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Weather" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -
#pragma mark Bar button action

- (IBAction)clearTapped:(id)sender
{
    self.title = @"";
    self.weather = nil;
    [self.tableView reloadData];
}

- (IBAction)jsonTapped:(id)sender
{
    //1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json",BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //3
        self.weather = (NSDictionary *)responseObject;
        self.title = @"JSON Retrieved";
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //4
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
    
    //5
    [operation start];
    
}

- (IBAction)plistTapped:(id)sender
{
    //1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=plist",BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    operation.responseSerializer = [AFPropertyListResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //3
        self.weather = (NSDictionary *)responseObject;
        self.title = @"Plist Retrieved";
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //4
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    //5
    [operation start];
    
}

- (IBAction)xmlTapped:(id)sender
{
    //1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=xml",BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //3
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //4
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    //5
    [operation start];
}



- (IBAction)clientTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"AFHTTPSessionManager" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"HTTP GET",@"HTTP POST", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}




#pragma mark UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==[actionSheet cancelButtonIndex]) {
        return;
    }
    //1
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = @{@"format":@"json"};
    
    //2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //3
    if (buttonIndex == 0)
    {
        [manager GET:@"weather.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            self.weather = responseObject;
            self.title = @"HTTP GET";
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }];
    }
    //4
    else if (buttonIndex == 1)
    {
        [manager POST:@"weather.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            self.weather = responseObject;
            self.title = @"HTTP POST";
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving Weather" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }];
    }
    
}

#pragma mark NSXMLParser delegate

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlWeather = [NSMutableDictionary dictionary];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementName = qName;
    if ([qName isEqualToString:@"current_condition"]||[qName isEqualToString:@"weather"]||[qName isEqualToString:@"request"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    self.outString = [NSMutableString string];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName) {
        return;
    }
    [self.outString appendFormat:@"%@",string];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //1
    if ([qName isEqualToString:@"current_condition"]||[qName isEqualToString:@"request"]) {
        self.xmlWeather[qName] = @[self.currentDictionary];
        self.currentDictionary = nil;
    }
    
    //2
    else if ([qName isEqualToString:@"weather"])
    {
        NSMutableArray *array = self.xmlWeather[@"weather"]?:[NSMutableArray array];
        
        [array addObject:self.currentDictionary];
        
        self.xmlWeather[@"weather"]=array;
        self.currentDictionary = nil;
    }
    
    //3
    else if ([qName isEqualToString:@"value"])
    {
        //ingnore value tags, they only appear in the two conditions below
    }
    
    //4
    else if ([qName isEqualToString:@"weatherDesc"]||[qName isEqualToString:@"weatherIconUrl"])
    {
        NSDictionary *dictionary = @{@"value":self.outString};
        NSArray *array = @[dictionary];
        self.currentDictionary[qName] = array;
    }
    
    //5
    else if (qName){
        self.currentDictionary[qName] = self.outString;
    }
    self.elementName = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.weather = @{@"data":self.xmlWeather};
    self.title = @"XML Retrieved";
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.weather) {
        return 0;
    }
    switch (section) {
        case 0:{
            return 1;
        }
        case 1:{
            NSArray *upcomingWeather = [self.weather upcomingWeatherInDays:5 withHourlyIndex:0];
            return [upcomingWeather count];
        }
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WeatherCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *daysWeather = nil;
    
    switch (indexPath.section) {
        case 0:
            daysWeather = [self.weather currentCondition];
            break;
        case 1:{
            NSArray *upcomingWeather = [self.weather upcomingWeatherInDays:5 withHourlyIndex:0];
            daysWeather = upcomingWeather[indexPath.row];
            break;
        }

        default:
            break;
    }
    
    cell.textLabel.text = [daysWeather weatherDescription];
    
    //weatherIcon async
    NSURL *url = [NSURL URLWithString:daysWeather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        //NSLog(@"%@",[self.weather currentCondition]);
    }
    else
    {
       //NSLog(@"%@",[self.weather upcomingWeatherInDays:5 withHourlyIndex:0]);
    }
}

#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"WeatherDetailSegue"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        RESWeatherAnimationViewController *weVC = (RESWeatherAnimationViewController *)segue.destinationViewController;
        
        NSDictionary *w;
        switch (indexPath.section) {
            case 0:{
                w = self.weather.currentCondition;
                break;
            }
            case 1:{
                w = [self.weather upcomingWeatherInDays:5 withHourlyIndex:0][indexPath.row];
                break;
            }
            default:
                break;
        }
        
        weVC.weatherDictionary = w;
        
    }
}

@end
