//
//  CellMateria.m
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CellMateria.h"

#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CellMateria
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.titulo setFont:[UIFont fontWithName:@"Zeppelin 33 Bold" size:12.0]];
    }
    return self;
}

- (void) initCell
{
    imageView = [[EGOImageView alloc] init];
    
    //imageView = [[EGOImageView alloc] init];
    imageView.frame = CGRectMake(0.0f, 0.0f, 120.0f, 69.0f);
    [self.contentView addSubview:imageView];
}

- (void)setThumbPhoto:(NSString*)photo {
	imageView.imageURL = [NSURL URLWithString:photo];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[imageView cancelImageLoad];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    
    return @"CustomCellIdentifier";
    
}

@end
