//
//  CellAjustes.m
//  MasterGuide
//
//  Created by Juliana Lima on 15/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CellAjustes.h"

@implementation CellAjustes
@synthesize titulo;
@synthesize habilita;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
