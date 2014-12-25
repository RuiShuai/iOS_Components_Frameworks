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

