//
//  CellDicas.h
//  MasterGuide
//
//  Created by Juliana Lima on 20/10/12.
//  Copyright (c) 2012 Flip Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface CellDicas : UITableViewCell
{
    EGOImageView* imageView;
}

@property (weak, nonatomic) IBOutlet UILabel *lb_titulo;
@property (weak, nonatomic) IBOutlet UITextView *lb_texto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregador;

+ (NSString *)reuseIdentifier;

- (void)initCell;
- (void)setThumbPhoto:(NSString*)photo;

@end
