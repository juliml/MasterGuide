//
//  MKMapView+Additions.m
//  ParkingMobility
//
//  Created by Michael Nachbaur on 10-09-12.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "MKMapView+Additions.h"

@implementation MKMapView (Additions)

- (UIImageView*)googleLogo {
	UIImageView *imgView = nil;
	for (UIView *subview in self.subviews) {
		if ([subview isMemberOfClass:[UIImageView class]]) {
			imgView = (UIImageView*)subview;
			break;
		}
	}
    
	return imgView;
}

@end
