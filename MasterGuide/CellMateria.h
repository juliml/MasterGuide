//
//  CellMateria.h
//  MasterGuide
//
//  Created by Juliana Lima on 26/09/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface CellMateria : UITableViewCell
{
    EGOImageView* imageView;
}
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UITextView *texto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregador;

+ (NSString *)reuseIdentifier;

- (void)initCell;
- (void)setThumbPhoto:(NSString*)photo;

@end
