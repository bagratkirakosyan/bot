//
//  Filter.h
//  effect-C
//
//  Created by Gagik Papoyan on 10/27/16.
//  Copyright © 2016 Gagik Papoyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Filter : NSObject

-(UIImage *)BlackAndWhite:(UIImage *)image;
-(UIImage *)Sepia:(UIImage *)image;
-(UIImage *)Chrome:(UIImage *)image;




@end
