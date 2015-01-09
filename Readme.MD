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
18 - Keychain
19 - Working With Images and Filters[ImagePlaygound]
20 - Collection Views[PhotoGallery]
21 - TextKit
22 - Gesture Recognizers[GesturePlayground]
23 - Accessing Photo Libraries[AssetLibraryNavigator]
24 - Passbook and PassKit


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



******************************
22 - Gesture Recognizers[GesturePlaygound]

2014-01-09,周五,中午完成练习




******************************
18 - Keychain[KeychainPlayground]

2014-01-09,周五,开启





******************************
21 - TextKit




******************************
24 - Passbook and PassKit




******************************
03 - Leaderboards





******************************
04 - Achievements




******************************
05 - Address Book






******************************
07- Getting JSON from the Server [MessageBoard]




******************************
08 - Getting Started with iCloud



******************************
09 - Notifications



******************************
10 - Bluetooth Messages




******************************
11 - AirPrint





******************************
15 - SocialNetworking



******************************
25 - Instruments



