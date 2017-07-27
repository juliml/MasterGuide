//
//  CellTelefone.m
//  MasterGuide
//
//  Created by Juliana Lima on 24/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import "CellTelefone.h"

@implementation CellTelefone

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
