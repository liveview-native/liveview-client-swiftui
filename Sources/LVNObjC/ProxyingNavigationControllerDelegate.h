//
//  ProxyingNavigationControllerDelegate.h
//  
//
//  Created by Shadowfacts on 6/13/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProxyingNavigationControllerDelegate : NSProxy<UINavigationControllerDelegate>

@property (nullable, nonatomic, weak) id<UINavigationControllerDelegate> first;
@property (nullable, nonatomic, weak) id<UINavigationControllerDelegate> second;

- (instancetype)initWithFirst:(id<UINavigationControllerDelegate>)first second:(id<UINavigationControllerDelegate>)second;

@end

NS_ASSUME_NONNULL_END
