2014-12-25 17:21:43.550 MyMovies[850:73643] file:///var/mobile/Containers/Data/Application/E5105BDB-88CF-409B-912B-AFC2BB984683/Documents/MyMovies.sqlite
2014-12-25 17:21:43.568 MyMovies[850:73643] CoreData: error: -addPersistentStoreWithType:SQLite configuration:(null) URL:file:///var/mobile/Containers/Data/Application/E5105BDB-88CF-409B-912B-AFC2BB984683/Documents/MyMovies.sqlite options:(null) ... returned error Error Domain=NSCocoaErrorDomain Code=134100 "The operation couldn’t be completed. (Cocoa error 134100.)" UserInfo=0x16d873f0 {metadata={
NSPersistenceFrameworkVersion = 519;
NSStoreModelVersionHashes =     {
Event = <5431c046 d30e7f32 c2cc8099 58add1e7 579ad104 a3aa8fc4 846e97d7 af01cc79>;
};
NSStoreModelVersionHashesVersion = 3;
NSStoreModelVersionIdentifiers =     (
""
);
NSStoreType = SQLite;
NSStoreUUID = "B78DC464-C2CF-4F19-980B-FBC41EDA301E";
"_NSAutoVacuumLevel" = 2;
}, reason=The model used to open the store is incompatible with the one used to create the store} with userInfo dictionary {
metadata =     {
NSPersistenceFrameworkVersion = 519;
NSStoreModelVersionHashes =         {
Event = <5431c046 d30e7f32 c2cc8099 58add1e7 579ad104 a3aa8fc4 846e97d7 af01cc79>;
};
NSStoreModelVersionHashesVersion = 3;
NSStoreModelVersionIdentifiers =         (
""
);
NSStoreType = SQLite;
NSStoreUUID = "B78DC464-C2CF-4F19-980B-FBC41EDA301E";
"_NSAutoVacuumLevel" = 2;
};
reason = "The model used to open the store is incompatible with the one used to create the store";
}
2014-12-25 17:21:43.570 MyMovies[850:73643] Unresolved error Error Domain=YOUR_ERROR_DOMAIN Code=9999 "Failed to initialize the application's saved data" UserInfo=0x16d85350 {NSLocalizedDescription=Failed to initialize the application's saved data, NSUnderlyingError=0x16d87440 "The operation couldn’t be completed. (Cocoa error 134100.)", NSLocalizedFailureReason=There was an error creating or loading the application's saved data.}, {
NSLocalizedDescription = "Failed to initialize the application's saved data";
NSLocalizedFailureReason = "There was an error creating or loading the application's saved data.";
NSUnderlyingError = "Error Domain=NSCocoaErrorDomain Code=134100 \"The operation couldn\U2019t be completed. (Cocoa error 134100.)\" UserInfo=0x16d873f0 {metadata={\n    NSPersistenceFrameworkVersion = 519;\n    NSStoreModelVersionHashes =     {\n        Event = <5431c046 d30e7f32 c2cc8099 58add1e7 579ad104 a3aa8fc4 846e97d7 af01cc79>;\n    };\n    NSStoreModelVersionHashesVersion = 3;\n    NSStoreModelVersionIdentifiers =     (\n        \"\"\n    );\n    NSStoreType = SQLite;\n    NSStoreUUID = \"B78DC464-C2CF-4F19-980B-FBC41EDA301E\";\n    \"_NSAutoVacuumLevel\" = 2;\n}, reason=The model used to open the store is incompatible with the one used to create the store}";
}
(lldb) 



2014-12-28 08:36:49.403 FavoritePlaces[1290:21558] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Can only use -performBlock: on an NSManagedObjectContext that was created with a queue.'
*** First throw call stack:
(
0   CoreFoundation                      0x00cd7946 __exceptionPreprocess + 182
1   libobjc.A.dylib                     0x005bfa97 objc_exception_throw + 44
2   CoreData                            0x008cb22f -[NSManagedObjectContext performBlock:] + 191
3   FavoritePlaces                      0x000c14c6 -[RESFavoritePlaceViewController saveButtonTouched:] + 278
4   libobjc.A.dylib                     0x005d57cd -[NSObject performSelector:withObject:withObject:] + 84
5   UIKit                               0x0131423d -[UIApplication sendAction:to:from:forEvent:] + 99
6   UIKit                               0x01684840 -[UIBarButtonItem(UIInternal) _sendAction:withEvent:] + 139
7   libobjc.A.dylib                     0x005d57cd -[NSObject performSelector:withObject:withObject:] + 84
8   UIKit                               0x0131423d -[UIApplication sendAction:to:from:forEvent:] + 99
9   UIKit                               0x013141cf -[UIApplication sendAction:toTarget:fromSender:forEvent:] + 64
10  UIKit                               0x01447e86 -[UIControl sendAction:to:forEvent:] + 69
11  UIKit                               0x014482a3 -[UIControl _sendActionsForEvents:withEvent:] + 598
12  UIKit                               0x0144750d -[UIControl touchesEnded:withEvent:] + 660
13  UIKit                               0x0136460a -[UIWindow _sendTouchesForEvent:] + 874
14  UIKit                               0x013650e5 -[UIWindow sendEvent:] + 791
15  UIKit                               0x0132a549 -[UIApplication sendEvent:] + 242
16  UIKit                               0x0133a37e _UIApplicationHandleEventFromQueueEvent + 20690
17  UIKit                               0x0130eb19 _UIApplicationHandleEventQueue + 2206
18  CoreFoundation                      0x00bfb1df __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 15
19  CoreFoundation                      0x00bf0ced __CFRunLoopDoSources0 + 253
20  CoreFoundation                      0x00bf0248 __CFRunLoopRun + 952
21  CoreFoundation                      0x00befbcb CFRunLoopRunSpecific + 443
22  CoreFoundation                      0x00bef9fb CFRunLoopRunInMode + 123
23  GraphicsServices                    0x03d2524f GSEventRunModal + 192
24  GraphicsServices                    0x03d2508c GSEventRun + 104
25  UIKit                               0x013128b6 UIApplicationMain + 1526
26  FavoritePlaces                      0x000cd05d main + 141
27  libdyld.dylib                       0x032c5ac9 start + 1
28  ???                                 0x00000001 0x0 + 1
)
libc++abi.dylib: terminating with uncaught exception of type NSException
(lldb) 

