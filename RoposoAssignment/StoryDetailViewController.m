//
//  StoryDetailViewController.m
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 03/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "Story.h"
#import "UIImageView+WebCache.h"
#import "Author.h"
#import "AppDelegate.h"

@interface StoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) Author *author;
@property (strong, nonatomic) NSString *followLabelText;

@end

@implementation StoryDetailViewController

static NSString *kFollowAuthorText = @"Follow";
static NSString *kUnFollowAuthorText = @"Unfollow";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self setViewDataForStory:self.story];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(handleBack:)];
//    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setViewDataForStory:(Story *)story
{
    self.titleLabel.text = story.title;
    self.descriptionLabel.text = story.descriptionText;
    self.authorLabel.text = story.author.name;
    
    self.author = [self getAuthor:story.authorId];
    self.followLabel.text = (self.author && self.author.followed.boolValue) ? kUnFollowAuthorText : kFollowAuthorText;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:story.image]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.storyImageView.image = image;
                            }
                        }];
}

- (void)handleBack:(id)sender {

    NSError *error = nil;
    if ([self.moc save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)followButtonClicked:(id)sender {

    if ([self.followLabel.text isEqualToString:kFollowAuthorText]) {
        self.followLabel.text = kUnFollowAuthorText;
        [self.author setFollowed:[NSNumber numberWithBool:YES]];
    }
    else {
        self.followLabel.text = kFollowAuthorText;
        [self.author setFollowed:[NSNumber numberWithBool:NO]];
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.moc];
    NSBatchUpdateRequest *request = [[NSBatchUpdateRequest alloc] initWithEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", self.author.identifier]];
    request.propertiesToUpdate = @{
                                   @"followed" : self.author.followed
                                   };
    request.resultType = NSUpdatedObjectsCountResultType;
    NSError *error = nil;
    NSBatchUpdateResult *res = (NSBatchUpdateResult *)[self.moc executeRequest:request error:&error];
    
    NSLog(@"%@ objects updated", res.result);
}

- (Author *)getAuthor:(NSString *)authorId
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

@end
