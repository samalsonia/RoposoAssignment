//
//  StoryCell.m
//  RoposoAssignment
//
//  Created by Tapasya  Samal on 02/06/16.
//  Copyright (c) 2016 Roposo. All rights reserved.
//

#import "StoryCell.h"
#import "Story.h"
#import "UIImageView+WebCache.h"
#import "Author.h"
#import "AppDelegate.h"

@interface StoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (strong, nonatomic) Author *author;

@end

@implementation StoryCell

static NSString *kFollowAuthorText = @"Follow";
static NSString *kUnFollowAuthorText = @"Unfollow";

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (CGFloat)height
{
    return 426;
}

- (void)assignCellDataWithStory:(Story *)story
{
    self.author = story.author;
    self.titleLabel.text = story.title;
    self.descriptionLabel.text = story.descriptionText;
    self.authorLabel.text = story.author.name;
    self.followLabel.text = story.author.followed.boolValue ? kUnFollowAuthorText : kFollowAuthorText;
    
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

- (IBAction)followButtonClicked:(id)sender
{
    if ([self.followLabel.text isEqualToString:kFollowAuthorText]) {
        self.followLabel.text = kUnFollowAuthorText;
        [self.author setFollowed:[NSNumber numberWithBool:YES]];
    }
    else {
        self.followLabel.text = kFollowAuthorText;
        [self.author setFollowed:[NSNumber numberWithBool:NO]];
    }
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc];
    NSBatchUpdateRequest *request = [[NSBatchUpdateRequest alloc] initWithEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", self.author.identifier]];
    request.propertiesToUpdate = @{
                                   @"followed" : self.author.followed
                                   };
    request.resultType = NSUpdatedObjectsCountResultType;
    NSError *error = nil;
    NSBatchUpdateResult *res = (NSBatchUpdateResult *)[moc executeRequest:request error:&error];
    
    NSLog(@"%@ objects updated", res.result);
}


@end
