//
//  KRConfettiView.m
//  KRConfetti
//
//  Created by Kieran (work account) on 04/02/2016.
//  Copyright © 2016 Robinson. All rights reserved.
//

#import "KRConfettiView.h"
#import <QuartzCore/QuartzCore.h>



@implementation KRConfettiView
@synthesize colours, intensity, type, emitter,customImage;

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    colours = @[[ICSingletonManager colorFromHexString:@"#001d3d"],
                [ICSingletonManager colorFromHexString:@"#bd9854"],
                [UIColor whiteColor]];
    intensity = 0.5;
    type = Confetti;
}
-(void)startConfetti {
    emitter = [[CAEmitterLayer alloc] init];
    emitter.emitterPosition = CGPointMake(self.center.x, 0);
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterSize = CGSizeMake(self.frame.size.width, 1);
    
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (UIColor *color in colours) {
        CAEmitterCell *cell = [self confettiWithColor:color];
        [cells addObject:cell];
    }
    
    emitter.emitterCells = cells;
    [self.layer addSublayer:emitter];
}

-(void)stopConfetti {
    emitter.birthRate = 0;
}

-(UIImage *)imageForType:(ConfettiType)imageType {
    NSString *fileName;
    
    switch (type) {
        case Confetti:
            fileName = @"confetti";
            break;
        case Star:
            fileName = @"starConfeti";
            break;
        case Triangle:
            fileName = @"triangle";
            break;
        case Diamond:
            fileName = @"diamond";
            break;
        case Custom:
            return customImage;
        default:
            break;
            
    }
    
    UIImage *image = [UIImage imageNamed:fileName];
    if (image) {
        return image;
    } else {
        return nil;
    }
}

-(CAEmitterCell *)confettiWithColor:(UIColor *)color {
    CAEmitterCell *confetti = [[CAEmitterCell alloc] init];
    confetti.birthRate = 16.0 * intensity;
    confetti.lifetime = 14.0 * intensity;
    confetti.lifetimeRange = 0;
    confetti.color = color.CGColor;
    confetti.velocity = (650.0 * intensity);
    confetti.velocityRange = (80.0 * intensity);
    confetti.emissionLongitude = (M_PI);
    confetti.emissionRange = (M_PI_4);
    confetti.spin = (3.5 * intensity);
    confetti.spinRange = (4.0 * intensity);
    confetti.scaleRange = (intensity);
    confetti.scaleSpeed = (-0.1 * intensity);
    UIImage *confettiImage = [self imageForType:type];
    confetti.contents = (__bridge id _Nullable)(confettiImage.CGImage);
    return confetti;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
