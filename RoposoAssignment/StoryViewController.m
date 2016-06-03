//
//  StoryViewController.m
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 03/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import "StoryViewController.h"
#import "Story.h"
#import "Author.h"
#import "AppDelegate.h"
#import "StoryCell.h"
#import "StoryDetailViewController.h"

@interface StoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *storiesTableView;

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation StoryViewController

static NSString *kCellIdentifier = @"storyCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Latest Stories";
    self.storiesTableView.delegate = self;
    self.storiesTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([StoryCell class]) bundle:nil];
    [self.storiesTableView registerNib:nib forCellReuseIdentifier:kCellIdentifier];
    
    self.stories = [[NSMutableArray alloc] init];
    self.moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self fetchData];
    [self.storiesTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.storiesTableView reloadData];
}

- (void)fetchData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOS-Android Data"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for(NSDictionary *item in jsonDataArray) {
        
        NSString *username = item[@"username"];
        if (username.length > 0) {
            [self addAuthor:item];
        }
        else {
            Story *story = [[Story alloc] initWithId:item[@"id"] authorId:item[@"db"] title:item[@"title"] description:item[@"description"] thumbnailImage:item[@"si"] imageUrl:item[@"url"]];
            [self.stories addObject:story];
        }
    }
    [self updateStoriesWithAuthorNames];
}

- (void)addAuthor:(NSDictionary *)item
{
    NSString *authorId = item[@"id"];
    Author *author = [self authorExists:authorId];
    if (!author) {
        Author *author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.moc];
        author.identifier = item[@"id"];
        author.name = item[@"username"];
        
        NSError *error = nil;
        if ([self.moc save:&error] == NO) {
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }
    }
}

- (void)updateStoriesWithAuthorNames
{
    for (Story *story in self.stories) {
        Author *author = [self authorExists:story.authorId];
        if (author) {
            story.author = author;
        }
    }
}

- (Author *)authorExists:(NSString *)authorId
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", authorId]];
    request.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *authors = [self.moc executeFetchRequest:request error:&error];
    if (authors.count > 0) {
        Author *author = [authors objectAtIndex:0];
        return author;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StoryCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryCell *cell = [[StoryCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    [cell assignCellDataWithStory:self.stories[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoryDetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:@"StoryDetailViewController"];
    [detailVC setStory:self.stories[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
