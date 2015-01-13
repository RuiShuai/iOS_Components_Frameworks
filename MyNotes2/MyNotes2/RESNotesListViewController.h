//
//  RESNotesListViewController.h
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRESMyNoteDocumentExtension @"resmynote"
#define kRESDisplayNoteDetailSegue @"showNoteDetail"
#define kRESDocumentDirectoryName @"Documents"
#define kRESMyNoteCellIdentifier @"NoteListCell"
#define kRESLastUpdatedNoteKey @"lastUpdatedNote"

@interface RESNotesListViewController : UITableViewController
{
    NSMutableArray *noteList;
    NSMetadataQuery *noteQuery;
}

@property (nonatomic,strong) NSString *lastUpdateNote;

- (NSString *)newMyNoteName;
- (NSMetadataQuery *)noteListQuery;
- (void)processFiles:(NSNotification *)notification;
- (void)updateLastUpdatedNote:(NSNotification *)notification;
- (IBAction)addButtonTouched:(id)sender;

@end
