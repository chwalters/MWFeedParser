//
//  DetailTableViewController.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DetailTableViewController.h"
#import "NSString+HTML.h"

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderURL } HeaderRows;
typedef enum { SectionDetailSummary } DetailRows;

@implementation DetailTableViewController

#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	// Super
    [super viewDidLoad];

	
}

- (void) viewWillAppear:(BOOL)animated
{
	// Date
	if (self.item.date) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
		self.dateString = [formatter stringFromDate:self.item.date];
		[formatter release];
	}
	
	// Summary
	if (self.item.summary) {
		self.summaryString = [self.item.summary stringByConvertingHTMLToPlainText];
	} else {
		self.summaryString = @"[No Summary]";
	}

    self.summaryView.text = self.summaryString;
    
    if (self.speechController) {
        self.speechController.speechUIDelegate = self;
        [self.speechController say:self.summaryString];
    }
    
    [super viewWillAppear:animated];
    
}
- (void) viewDidAppear:(BOOL)animated
{
    //[self.itemTableView reloadData];
    [super viewDidAppear:animated];

}

- (void) viewWillDisappear:(BOOL)animated
{
    if (self.speechController) {
        [self.speechController stop];
    }
}

- (void) showUIToStartSpeaking
{
    [self.summaryView becomeFirstResponder];
    [self.summaryView setSelectedTextRange:nil];
}

- (void) showUIForSpeakingRange:(NSRange)range ofSpeechString:(NSString *)string
{
    [self.summaryView setSelectedRange:range];
    [self.summaryView scrollRangeToVisible:range];
}

- (void) showUIToStopSpeaking
{
    [self.summaryView setSelectedTextRange:nil];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [textView setSelectedRange:NSMakeRange(0, 0)];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger retVal = 3;
    return retVal;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Display
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	if (self.item) {
		
		// Item Info
		NSString *itemTitle = self.item.title ? [self.item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		
		// Display
		switch (indexPath.section) {
			case SectionHeader: {
				
				// Header
				switch (indexPath.row) {
					case SectionHeaderTitle:
						cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
						cell.textLabel.text = itemTitle;
						break;
					case SectionHeaderDate:
						cell.textLabel.text = self.dateString ? self.dateString : @"[No Date]";
						break;
					case SectionHeaderURL:
						cell.textLabel.text = self.item.link ? self.item.link : @"[No Link]";
						cell.textLabel.textColor = [UIColor blueColor];
						cell.selectionStyle = UITableViewCellSelectionStyleBlue;
						break;
				}
				break;
				
			}
			case SectionDetail: {
				
				// Summary
				cell.textLabel.text = self.summaryString;
				cell.textLabel.numberOfLines = 0; // Multiline
				break;
				
			}
		}
	}
    
    return cell;
	
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SectionHeader) {
		
		// Regular
		return 34;
		
	} else {
		
		// Get height of summary
		NSString *summary = @"[No Summary]";
		if (self.summaryString) summary = self.summaryString;
		CGSize s = [summary sizeWithFont:[UIFont systemFontOfSize:15]
					   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
						   lineBreakMode:NSLineBreakByWordWrapping];
		return s.height + 16; // Add padding
		
	}
}
*/
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
	// Open URL
	if (indexPath.section == SectionHeader && indexPath.row == SectionHeaderURL) {
		if (self.item.link) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item.link]];
		}
	}
	
	// Deselect
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
*/
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.dateString = nil;
    self.summaryString = nil;
    self.item = nil;
    self.itemTableView = nil;
    self.summaryView = nil;
    self.speechController = nil;

    [super dealloc];
}


@end

