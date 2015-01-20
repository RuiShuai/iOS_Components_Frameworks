【 iOS Components and Frameworks: Understanding the Advanced Features of iOS】（2013.8）
《iOS组件与框架——iOS SDK高级特性剖析》

01 - UIKIT Dynamics [Dynamics]
02 - Core Location, MapKit, and Geofencing  [FavoritePlaces]
03 - Leaderboards
04 - Achievements
05 - Address Book
06 - Music Libraries [MediaPlayer]
07 - Getting JSON from the Server [MessageBoard]
08 - Getting Started with iCloud
09 - Notifications
10 - Bluetooth Messages
12 - Core Data Primer[/]
13 - Core Data Up and Running [MyMovies]
14 - Language Features[/]
15 - SocialNetworking
16 - Working With Background Tasks[BackgroundTasks]
17 - GCD for Performance[LongRunningTasks]
18 - Keychain[KeychainPlayground]
19 - Working With Images and Filters[ImagePlaygound]
20 - Collection Views[PhotoGallery]
21 - TextKit[TextKit]
22 - Gesture Recognizers[GesturePlayground]
23 - Accessing Photo Libraries[AssetLibraryNavigator]
24 - Passbook and PassKit[PassKit]


******************************

01- UIKit Dynamics [Dynamics]

【2014-12-20,周六】,Dynamics,xib tableview 7 cell

Gravity重力效果
Collision碰撞效果
Attachment连接效果
Spring弹簧效果
Snap吸附效果
Force推力效果
Properties物理属性


******************************
02 - Core Location, MapKit, and Geofencing [FavoritePlaces]

2014-12-22,周二,15:00,FavoritePlaces


******************************
12 - Core Data Primer
13 - Core Data Up and Running [MyMovies]
14 - Language Features

2014-12-23,周二,阅读完毕。

2014-12-24,周四,
Note
There is a project called mogenerator that will generate two classes per entity: one for the attribute accessors and one for custom logic. That way, you can regenerate classes easily when making model changes without overwriting your custom logic. 
Mogenerator is available at http://rentzsch.github.com/mogenerator/.

Mogenerator:generates Objective-C code for your Core Data custom classes

Unlike Xcode, mogenerator manages two classes per entity: one for machines, one for humans

The machine class can always be overwritten to match the data model, with humans’ work effortlessly preserved

Download
Download mogenerator 1.28
or install via homebrew:
$ brew install mogenerator
upgrading using homebrew:
$ brew update && brew upgrade mogenerator

mogenerator --version
mogenerator 1.28. By Jonathan 'Wolf' Rentzsch + friends.
mogenerator --model MyMovies.xcdatamodeld/
4 machine files and 4 human files generated.

P303,Introducing the Fetched Results Controller
A fetched results controller (NSFetchedResultsController) is a very effective liaison between Core Data and a UITableView. The fetched results controller provides a way to set up a fetch request so that the results are returned in sections and rows, accessible by index paths. In addi- tion, the fetched results controller can listen to changes in Core Data and update the table accordingly using delegate methods.


******************************
06 - Music Libraries [MediaPlayer]

【2014-12-29，周一】，第6章，【MediaPlayer】
player = [MPMusicPlayerController systemMusicPlayer];//applicationMusicPlayer];



******************************
19 - Working With Images and Filters[imagePlayground]

2015-01-06,周二,完成imagePlayground的ipad程序
filterDelegate传递,继承cell单元格



******************************
23 - Accessing Photo Libraries[AssetLibraryNavigator]

2015-01-06,周二,下午完成类photo读取程序
AssetLibrary,AssetGroup,AssetDetail

核心函数：
1)
ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
[al enumerateGroupsWithTypes:ALAssetsGroupAll
usingBlock:enumerateAssetGroupsBlock
failureBlock:assetGroupEnumErrorBlock];

2)
[self.assetLibrary groupForURL:self.assetGroupURL
resultBlock:retrieveGroupBlock
failureBlock:handleAssetGroupErrorBlock];

3)
[self enumerateGroupAssetsForGroup:group];
[group enumerateAssetsUsingBlock:addAsset];



******************************
20 - Collection Views[PhotoGallery]

2014-01-06,周二,16:27,折腾ALAssetLibrary,AssetGroup,Assets;
2014-01-07,周三,正式photoGallery练习。
2014-01-08,周四,16:52,完成添加书籍托盘效果,波浪式装饰效果.



******************************
17 - GCD for Performance[LongRunningTasks]
16 - Working With Background Tasks[BackgroundTasks]

2014-01-08,周四,上午阅读
2014-01-09,周五,开始正式练习

//定义分发队列
dispatch_queue_t workQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

//异步进程执行
dispatch_async(workQueue, ^{
[self performLongRunningTaskForIteration:iteration];
});

-(void)performLongRunningTaskForIteration:(id)iteration
{
NSNumber *iterationNumber = (NSNumber *)iteration;

__block NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];

//定义分发队列
dispatch_queue_t detailQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

//应用分发线程
size_t loop = (size_t)[iterationNumber intValue];
dispatch_apply(loop, detailQueue, ^(size_t i) {
[newArray addObject:[NSString stringWithFormat:@"Item %@-%zu",iterationNumber,i+1]];
[NSThread sleepForTimeInterval:0.1];
NSLog(@"DpQ Concurrent Added %@-%zu",iterationNumber,i+1);
});

//调用主线程更新UI
dispatch_async(dispatch_get_main_queue(), ^{
[self updateTableData:newArray];
});

}


******************************
22 - Gesture Recognizers[GesturePlaygound]

2014-01-09,周五,中午完成练习

UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(myGestureViewRotated:)];
[rotateRecognizer setDelegate:self];
[self.myGestureView addGestureRecognizer:rotateRecognizer];

- (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture
{
CGFloat newRotateRadians = [rotateGesture rotation];

//set rotationDelta
[self updateViewTransformWithScaleDelta:0.0 andRotationDelta:newRotateRadians];
if ([rotateGesture state] == UIGestureRecognizerStateEnded) {
CGFloat saveRotation = [self rotationFactor] + newRotateRadians;
[self setRotationFactor:saveRotation];
[self setCurrentRotationDelta:0.0];
}

}

******************************
18 - Keychain[KeychainPlayground]

2014-01-09,周五,项目准备
2014-01-10,周六,完成keychain章节，UIAlertView + textField交互。


******************************
24 - Passbook and PassKit[PassKit]
21 - TextKit[TextKit]

2015-01-11,周一,上午完成PassKit，但没有很好得到结果，怀疑是没有iOS开发者账号缘故；
下午先阅读TextKit，然后在电脑上写代码，晚上完成。
对NSTextStorage工作区的功能类仔细研究了一番，写得比较好。
迭代token字典用到usingBlock，这样的代码值得作为基础，日后直接拿过来使用。

[[self string] enumerateSubstringsInRange:searchRange
options:NSStringEnumerationByWords
usingBlock:
^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
if (!attributesForToken) {
attributesForToken = defaultAttributes;
}
[self addAttributes:attributesForToken range:substringRange];
}];



******************************
05 - Address Book[AddressBook]
08 - Getting Started with iCloud[MyNotes]

2015-01-13,周二,上午完成AddressBook,结合之前MyContacts中，添加了授权后，可以正常显示.

下午，开始MyNotes(iCloud),这是一个比较综合的案例,代码写得很有功底,值得仔细研究.
涉及到:
UIDocument
notification通知
delegate委托
GCD性能优化
pageViewController
iCloud版本冲突处理

通过这些案例代码的抄写，才算找到了些感觉.
接下来申请下来开发者账号之后,notification通知值得好好书写.

2015-01-13 20:19:45.977 MyNotes2[904:74991] iCloud URL is not avaliable
2015-01-13 20:19:48.287 MyNotes2[904:74957] NSUbiquitousKeyValueStore error: com.ruishuai.MyNotes2 has no valid com.apple.developer.ubiquity-kvstore-identifier entitlement



******************************
07- Getting JSON from the Server [MessageBoard]



******************************
15 - SocialNetworking[SocialNetworking]






******************************
10 - Bluetooth Messages[Bluetooth_message]


#import "RESBluetoothConnectViewController.h"
#import "UIActionSheet+Blocks.h"
#define kBluetoothMessagesServiceType  @"bluetoothmessages-service"
#define kActionSheetAdvertiser 1

#pragma mark - MCNearbyServiceAdvertiser delegate
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
//被阻止
if ([self.mutableBlockedPeers containsObject:peerID]) {
invitationHandler(NO,nil);
return;
}


//actionSheet(category)
[UIActionSheet showInView:self.view
withTitle:[NSString stringWithFormat:NSLocalizedString(@"Received Invitation from %@", @"Received Invitation from {Peer}"), peerID.displayName]
cancelButtonTitle:NSLocalizedString(@"Reject", nil)
destructiveButtonTitle:NSLocalizedString(@"Block", nil)
otherButtonTitles:@[NSLocalizedString(@"Accept", nil)]
tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {

BOOL acceptedInvitation = (buttonIndex == [actionSheet firstOtherButtonIndex]);
if (buttonIndex == [actionSheet destructiveButtonIndex]) {
[self.mutableBlockedPeers addObject:peerID];
}

//Creating a session
MCSession *session = [[MCSession alloc]initWithPeer:self.localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];

session.delegate = self;
self.session = session;

invitationHandler(acceptedInvitation,(acceptedInvitation ? session :nil));

}];





}






******************************
09 - Notifications[ShoutOut_APN]






******************************
03 - Leaderboards[WhackACac_iPad]
04 - Achievements







******************************
25 - Instruments



