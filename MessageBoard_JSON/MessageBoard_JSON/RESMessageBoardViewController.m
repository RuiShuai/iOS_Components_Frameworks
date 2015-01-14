//
//  RESMessageBoardViewController.m
//  MessageBoard_JSON
//
//  Created by taotao on 15/1/13.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESMessageBoardViewController.h"
#import "RESMessageNewViewController.h"

@interface RESMessageBoardViewController ()
@property (nonatomic,strong) NSMutableData *connectionData;
@end

@implementation RESMessageBoardViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    //show activity indicator
    [self showActivityIndicatorViewInNavigationItem];

}


#pragma mark -

- (void)showActivityIndicatorViewInNavigationItem
{
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = actView;
    [actView startAnimating];
    self.navigationItem.prompt = @"数据加载中...";
}

-(void)refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];

        //query data
        [self loadMessages];
        [self.tableView reloadData];
    }
}

- (BOOL) loadMessages
{
    NSURL *msgURL = [NSURL URLWithString:kMessageBoardURLString];
    NSURLRequest *msgRequest = [NSURLRequest requestWithURL:msgURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLConnection *theConn = [[NSURLConnection alloc] initWithRequest:msgRequest delegate:self];
    if (theConn) {
        NSMutableData *connData = [[NSMutableData alloc]init];
        [self setConnectionData:connData];
    }else{
        NSLog(@"Connection failed...");
        //end refreshing
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.refreshControl beginRefreshing];
    
    //load messages
    [self loadMessages];
    
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NSURLConnection delegate methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.connectionData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.connectionData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    connection = nil;
    self.connectionData = nil;
    NSLog(@"Connection failed. Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *retString = [NSString stringWithUTF8String:[self.connectionData bytes]];
    //NSLog(@"json returned: %@",retString);
    
    NSError *parseError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.connectionData options:0 error:&parseError];
    
    if (!parseError) {
        [self setMessageArray:jsonArray];
        //NSLog(@"json array is %@",jsonArray);
        [self.tableView reloadData];
    }else{
        NSString *err = [parseError localizedDescription];
        NSLog(@"Encountered error parsing: %@",err);
    }
    connection = nil;
    self.connectionData = nil;
    
    //停止下拉刷新
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }

    //停止activity indicator指示器
    self.navigationItem.titleView = nil;
    self.navigationItem.prompt = nil;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.messageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"msgCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *message = (NSDictionary *)[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    NSString *byLabel = [NSString stringWithFormat:@"by %@ on %@",[message objectForKey:@"name"],[message objectForKey:@"message_date"]];
    
    cell.textLabel.text = [message objectForKey:@"message"];
    cell.detailTextLabel.text = byLabel;
    
    return cell;
}



#pragma mark - RESMyNoteDocumentDelegate
- (void)createNewMessage:(NSDictionary *)messageDict withPostError:(NSError *)error
{

    
    //异步更新
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            NSLog(@"success create message: %@",messageDict);
        }
        
        
    });
}

#pragma mark - New Message
- (IBAction)newMessageTouched:(id)sender
{

    [self performSegueWithIdentifier:@"newMsgSegue" sender:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newMsgSegue"]) {
        UINavigationController *navC = (UINavigationController *)[segue destinationViewController];
        RESMessageNewViewController *mnVC = (RESMessageNewViewController *)navC.viewControllers[0];
        [mnVC setDelegate:self];
        
        
        NSDictionary *msg = @{@"name":@"taojunjun",
                              @"message":@"New Message content...",
                              @"message_date":[NSDate date]};
        
        [mnVC setMessageDict:msg];
    }
    
}


@end
