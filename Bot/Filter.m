//
//  Filter.m
//  effect-C
//
//  Created by Gagik Papoyan on 10/27/16.
//  Copyright © 2016 Gagik Papoyan. All rights reserved.
//

#import "Filter.h"

@implementation Filter

-(UIImage *)Sepia:(UIImage *)image {
    CIImage *beginImage = [[CIImage alloc] initWithImage: image];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    return newImage;
}

-(UIImage *)BlackAndWhite:(UIImage *)image {
    CIImage *beginImage = [[CIImage alloc] initWithImage: image];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"
                                  keysAndValues: kCIInputImageKey, beginImage, nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    return newImage;
}

-(UIImage *)Chrome:(UIImage *)image {
    CIImage *beginImage = [[CIImage alloc] initWithImage: image];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"
                                  keysAndValues: kCIInputImageKey, beginImage, nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    return newImage;
}

@end
