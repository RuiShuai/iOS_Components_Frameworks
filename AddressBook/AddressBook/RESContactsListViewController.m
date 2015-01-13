//
//  RESContactsListViewController.m
//  AddressBook
//
//  Created by taotao on 15/1/12.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESContactsListViewController.h"

@interface RESContactsListViewController ()

@end

@implementation RESContactsListViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get addressBook
    
    CFErrorRef *error = nil;
    
    self.addressBook = ABAddressBookCreateWithOptions(nil, error);
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {//基于授权
            //查询所有
            //[self filterContentForSearchText:nil];
            
            NSLog(@"%@",ABAddressBookCopyArrayOfAllSources(self.addressBook));
             
            //let the user know if the address book is empty
            if (ABAddressBookGetPersonCount(self.addressBook)==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Address book is empty!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
             }
             
            //get an array filled with all the records we find in the address book
            self.addressBookEntryArray = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
             
            /*
            //create a new person
            if ([self programmaticallyCreatePerson]) {
                [self.tableView reloadData];
            }
             */
            [self.tableView reloadData];
        }
    });
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    CFRelease(CFBridgingRetain(self.addressBook));
}

- (void)dealloc
{
    CFRelease(CFBridgingRetain(self.addressBook));
}


#pragma mark - actions
- (IBAction)addNewPerson:(id)sender
{
    //init Nav + NewPersonVC
    ABNewPersonViewController *newPersonVC = [[ABNewPersonViewController alloc]init];
    UINavigationController *newPersonNC = [[UINavigationController alloc]initWithRootViewController:newPersonVC];
    
    //set the delegate
    [newPersonVC setNewPersonViewDelegate:self];
    
    //modal弹出新视图
    [self presentViewController:newPersonNC animated:YES completion:nil];
    
}


- (BOOL)programmaticallyCreatePerson
{
    
    ABRecordRef newPersonRecord = ABPersonCreate();
    
    CFErrorRef error = NULL;
    
    //set the new persons first and last name
    ABRecordSetValue(newPersonRecord, kABPersonFirstNameProperty, @"Tyler", &error);
    ABRecordSetValue(newPersonRecord, kABPersonLastNameProperty, @"Durden", &error);
    
    //set business name and job title
    ABRecordSetValue(newPersonRecord, kABPersonOrganizationProperty, @"Paperstreet Soap Company", &error);
    ABRecordSetValue(newPersonRecord, kABPersonJobTitleProperty, @"Salesman", &error);
    
    //set the phone numbers
    ABMutableMultiValueRef multiPhoneRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-800-555-5555", kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-203-426-1234", kABPersonPhoneMobileLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-555-555-0123", kABPersonPhoneIPhoneLabel, NULL);
    ABRecordSetValue(newPersonRecord, kABPersonPhoneProperty, multiPhoneRef, nil);
    CFRelease(multiPhoneRef);
    
    //set email address
    ABMutableMultiValueRef multiEmailRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmailRef, @"tyler@paperstreetsoap.com", kABWorkLabel, NULL);
    ABRecordSetValue(newPersonRecord, kABPersonEmailProperty, multiEmailRef, &error);
    CFRelease(multiEmailRef);
    
    //set address
    ABMutableMultiValueRef multiAddressRef = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
    
    [addressDict setObject:@"152 Paper Street" forKey:(NSString *)kABPersonAddressStreetKey];
    [addressDict setObject:@"Delaware" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDict setObject:@"MD" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDict setObject:@"19963" forKey:(NSString *)kABPersonAddressZIPKey];
    
    ABMultiValueAddValueAndLabel(multiAddressRef, CFBridgingRetain(addressDict), kABWorkLabel, NULL);
    ABRecordSetValue(newPersonRecord, kABPersonAddressProperty, multiAddressRef, &error);
    CFRelease(multiAddressRef);
    
    ABAddressBookAddRecord(self.addressBook, newPersonRecord, &error);
    ABAddressBookSave(self.addressBook, &error);
    
    if (error != NULL) {
        NSLog(@"An error occurred");
        return NO;
    }
    
    CFRelease(CFBridgingRetain(self.addressBookEntryArray));
    self.addressBookEntryArray = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
    
    return YES;
}


- (IBAction)toggleAddress:(id)sender
{
    if (self.showingAddress) {
        [self.toggleButton setTitle:@"Toggle Address"];
    }else{
        [self.toggleButton setTitle:@"Toggle Phone"];
    }
    
    self.showingAddress = !self.showingAddress;
    
    [self.tableView reloadData];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.addressBookEntryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ABRecordRef record = (__bridge ABRecordRef)([self.addressBookEntryArray objectAtIndex:indexPath.row]);
    NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
    NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
    
    //subtitleString
    NSString *subtitleString = nil;
    
    //show address info
    if (self.showingAddress) {
        ABMultiValueRef streetAddresses = ABRecordCopyValue(record, kABPersonAddressProperty);
        
        //at least one address for this record
        if (ABMultiValueGetCount(streetAddresses) > 0)
        {
            NSDictionary *streetAddressDictionary = (NSDictionary *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(streetAddresses, 0));
            
            //find the individual address components
            NSString *street = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            NSString *city = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            NSString *state = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
            NSString *zip = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];
            
            subtitleString = [NSString stringWithFormat: @"%@ %@, %@ %@", street, city, state, zip];
            
            CFRelease(CFBridgingRetain(streetAddressDictionary));
        }
        //no addresses for this record
        else
        {
            subtitleString = @"[None]";
        }
        
        
    }
    //show phone number info
    else
    {
        CFStringRef phoneNumber = nil;
        
        //get a copy of all the phone numbers for this person
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        //if we have any numbers use the first one we find
        if (ABMultiValueGetCount(phoneNumbers) > 0)
        {
            phoneNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            CFStringRef phoneTypeRawString = ABMultiValueCopyLabelAtIndex(phoneNumbers, 0);
            
            /*
             Phone type labels are values like "_$!<Mobile>!$_", we need to localize the type for display
             */
            
            NSString *localizedPhoneTypeString =  (NSString *)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(phoneTypeRawString));
            
            subtitleString = [NSString stringWithFormat:@"%@ [%@]", phoneNumber, localizedPhoneTypeString];
            
            CFRelease(phoneNumber);
            CFRelease(phoneTypeRawString);
            CFRelease(CFBridgingRetain(localizedPhoneTypeString));
        }
        
        //no phone numbers
        else
        {
            subtitleString = @"[None]";
        }
        
        CFRelease(phoneNumbers);
        

    }
    
    //configure cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    cell.detailTextLabel.text = subtitleString;
    
    //NIL may of been retrieved and CFRelease doesnt gracefully handle nils;
    if (firstName) {
        CFRelease(CFBridgingRetain(firstName));
    }
    if (lastName) {
        CFRelease(CFBridgingRetain(lastName));
    }
    
    return cell;
}


#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //init personVC
    ABPersonViewController *personVC = [[ABPersonViewController alloc]init];
    personVC.personViewDelegate = self;//set delegate
    personVC.displayedPerson = CFBridgingRetain([self.addressBookEntryArray objectAtIndex:indexPath.row]);
    
    personVC.allowsActions = YES;//allows inline calling maping
    personVC.allowsEditing = YES;//we can edit inline
    
    //show personVC
    [self.navigationController pushViewController:personVC animated:YES];
    
    
}

#pragma mark - ABPersonViewController delegate
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return  YES;
}


#pragma mark - ABNewPersonViewController delegate
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) {
        CFErrorRef error = NULL;
        ABAddressBookAddRecord(self.addressBook, person, &error);
        ABAddressBookSave(self.addressBook, &error);
        if (error != NULL) {
            NSLog(@"An error occurred");
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //refresh
    CFRelease(CFBridgingRetain(self.addressBookEntryArray));
    self.addressBookEntryArray = (NSArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
    [self.tableView reloadData];
    
}



#pragma mark - ABPeoplePickerNavigationController delegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSLog(@"You have selected: %@",person);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"Person: %@\nProperty:%i\nIdentifier:%i",person,property,identifier);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
