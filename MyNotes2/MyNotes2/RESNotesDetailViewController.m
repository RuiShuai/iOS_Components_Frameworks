//
//  RESNotesDetailViewController.m
//  MyNotes2
//
//  Created by taotao on 15/1/9.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESNotesDetailViewController.h"

@interface RESNotesDetailViewController ()
- (void)configureView;
@end

@implementation RESNotesDetailViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //update view
    [self configureView];
    
    
}


- (void)configureView
{
    [self.myNoteTextView setText:@""];
    
    //init RESMyNoteDocument
    self.myNoteDocument = [[RESMyNoteDocument alloc]initWithFileURL:[self myNoteURL]];
    
    [self.myNoteDocument setDelegate:self];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[self.myNoteURL path]]) {
        [self.myNoteDocument openWithCompletionHandler:^(BOOL success) {
            
            [self.myNoteTextView setText:[self.myNoteDocument myNoteText]];
            UIDocumentState state = self.myNoteDocument.documentState;
            
            if (state == UIDocumentStateNormal) {
                [self.myNoteTextView becomeFirstResponder];
            }
            
        }];
    }else{
        [self.myNoteDocument saveToURL:self.myNoteURL forSaveOperation:UIDocumentSaveForCreating completionHandler:nil];
        [self.myNoteTextView becomeFirstResponder];
    }
    
    NSUbiquitousKeyValueStore *iCloudKeyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    NSString *noteName = [[self.myNoteURL lastPathComponent] stringByDeletingPathExtension];
    
    [iCloudKeyValueStore setString:noteName forKey:kRESLastUpdatedNoteKey];
    [iCloudKeyValueStore synchronize];
    
}


#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //add observer
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter addObserver:self selector:@selector(documentStateChanged) name:UIDocumentStateChangedNotification object:self.myNoteDocument];
    [notifiCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notifiCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //save document
    NSString *newText = [self.myNoteTextView text];
    [self.myNoteDocument setMyNoteText:newText];
    
    [self.myNoteDocument closeWithCompletionHandler:nil];
    
    //remove observer
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter removeObserver:self name:UIDocumentStateChangedNotification object:self.myNoteDocument];
    [notifiCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notifiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - notification methods
- (void)documentStateChanged
{
    UIDocumentState state = self.myNoteDocument.documentState;
    if (state & UIDocumentStateEditingDisabled) {
        [self.myNoteTextView resignFirstResponder];//giveup focus
        return;
    }
    
    if (state & UIDocumentStateInConflict) {
        [self showConflictButton];
        return;
    }
    else{
        [self hideConflictButton];
        [self.myNoteTextView becomeFirstResponder];
    }
}


- (void)showConflictButton
{
    [self.conflictButton setHidden:NO];
    [self.myNoteTextView resignFirstResponder];
}

- (void)hideConflictButton
{
    [self.conflictButton setHidden:YES];
}

#pragma mark -
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets insets = self.myNoteTextView.contentInset;
    insets.bottom += kbSize.size.height;
    //置于下方
    [UIView animateWithDuration:duration animations:^{
        self.myNoteTextView.contentInset = insets;
    }];
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    //Reset the text view's botton content inset;
    UIEdgeInsets insets = self.myNoteTextView.contentInset;
    insets.bottom = 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.myNoteTextView.contentInset = insets;
    }];
}



#pragma mark - RESMyNoteDocumentDelegate
- (void)documentContentsDidChange:(RESMyNoteDocument *)document
{
    //异步更新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myNoteTextView setText:[document myNoteText]];
    });
}

#pragma mark - RESMyNoteConflictDelegate
- (void)noteConflictResolved:(NSFileVersion *)selectedVersion forCurrentVersion:(BOOL)isCurrentVersion
{
    //resolve conflict
    if (isCurrentVersion) {
        
        [NSFileVersion removeOtherVersionsOfItemAtURL:self.myNoteDocument.fileURL error:nil];
        
        NSArray *conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:self.myNoteDocument.fileURL];
        
        for (NSFileVersion *fileVersion in conflictVersions) {
            fileVersion.resolved = YES;
        }
        
    }else{
        [selectedVersion replaceItemAtURL:self.myNoteDocument.fileURL options:0 error:nil];
        
        [NSFileVersion removeOtherVersionsOfItemAtURL:self.myNoteDocument.fileURL error:nil];
        
        NSArray *conflictVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:self.myNoteDocument.fileURL];
        
        for (NSFileVersion* fileVersion in conflictVersions) {
            fileVersion.resolved = YES;
        }
        
    }
    
    [self configureView];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
- (IBAction)resolveConflictTouched:(id)sender
{
    NSArray *versions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:self.myNoteURL];
    
    NSFileVersion *currentVersion = [NSFileVersion currentVersionOfItemAtURL:self.myNoteURL];
    
    NSMutableArray *conflictVersions = [NSMutableArray arrayWithObject:currentVersion];
    
    [conflictVersions addObjectsFromArray:versions];
    
    //pragmatically segue
    RESConflictResolutionViewController *conflictResolverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RESConflictResolutionViewController"];
    
    [conflictResolverVC setVersionList:conflictVersions];
    [conflictResolverVC setCurrentVersion:currentVersion];
    [conflictResolverVC setConflictNoteURL:self.myNoteURL];
    [conflictResolverVC setDelegate:self];
    
    [self presentViewController:conflictResolverVC animated:YES completion:nil];
    
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


@end
