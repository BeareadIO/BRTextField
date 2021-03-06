//
//  BRTextField.h
//  BRTextField
//
//  Created by Archy on 2017/9/26.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BRTextFieldStyle) {
    BRTextFieldStyleDefault,
    BRTextFieldStyleClose,
    BRTextFieldStylePassword,
    BRTextFieldStyleVerifyCode,
    BRTextFieldStyleInternational,
};


@protocol BRTextFieldDelegate;
IB_DESIGNABLE
/**
 An object that displays an editable text area in your interface.
 
 It will display an underline and a floating label.
 */
@interface BRTextField : UIView

@property (nonatomic, strong, readonly) UITextField               *textField;

@property (nonatomic) BRTextFieldStyle   style;

@property (nullable, nonatomic, weak)   id<BRTextFieldDelegate> delegate;             // default is nil. weak reference
/**
 Whether Need Underline. default is YES. line width is 1;
 */
@property (assign, nonatomic, getter=isNeedUnderline)IBInspectable BOOL needUnderLine;
/**
 Whether Need Animation. default is YES.
 */
@property (assign, nonatomic, getter=isNeedAnimation)IBInspectable BOOL needAnimation;
/**
 Whether Need Floating. default is YES.
 */
@property (assign, nonatomic, getter=isNeedFloating) IBInspectable BOOL needFloating;
/**
 The color for underline. default is nil. use opaque black
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor     *underlineColor;

@property (nullable, nonatomic, copy)IBInspectable   NSString      *placeholder;          // default is nil. string is drawn 70% gray
@property (nonatomic) NSTextAlignment    textAlignment;        // default is NSLeftTextAlignment
@property (nonatomic) UIKeyboardType     keyboardType;

@property (nullable, nonatomic, strong)IBInspectable UIColor                *textColor;            // default is nil. use opaque black
@property (nullable, nonatomic, strong) UIFont                 *font;                 // default is nil. use system font 17 pt
@property (nullable, nonatomic, strong) IBInspectable NSString   *floatText; // default is equal placeholder.
@property (nullable, nonatomic, strong) IBInspectable UIColor    *floatColor; // default
@property (nullable, nonatomic, strong) UIFont                   *floatFont;   // default is nil. use system font 15 pt
/**
 Custom Left or Right View Properties
 */
/**
 Supply Text Color
 */
@property (nullable, nonatomic, weak) IBInspectable  UIColor    *supplyColor;
/**
 Supply Text Content
 */
@property (nullable, nonatomic, strong)IBInspectable  NSString                *supplyText; // default is nil.
/**
 Supply View Enabled
 */
@property (assign, nonatomic, getter=isSupplyEnabled)IBInspectable  BOOL      supplyEnabled;
@end

@protocol BRTextFieldDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)textFieldDidClickSupplyView:(BRTextField *)textField;

@end

NS_ASSUME_NONNULL_END

