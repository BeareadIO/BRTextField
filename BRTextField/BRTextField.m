//
//  BRTextField.m
//  BRTextField
//
//  Created by Archy on 2017/9/26.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "BRTextField.h"

#define FloatFadeInDuration 0.2
#define FloatFadeOutDuration 0.3

@interface BRTextField ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel     *lblFloat;
@property (strong, nonatomic) UIView      *underlineView;

@end


@implementation BRTextField

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateUI];
}

- (void)propertyInit {
    _needUnderLine = YES;
    _needAnimation = YES;
    _needFloating = YES;
    
    self.clipsToBounds = NO;
}

- (void)updateUI {
    if (!self.textColor) {
        self.textColor = [UIColor blackColor];
    }
    if (!self.floatColor) {
        self.floatColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
    }
    self.lblFloat.textColor = self.floatColor;
    [self addSubview:self.textField];
    [self addSubview:self.lblFloat];
    [self addSubview:self.underlineView];
    
    [self.textField addTarget:self action:@selector(inputDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self updateFrame];
}

- (void)deviceOrientationDidChange {
    [self updateFrame];
}

- (void)updateFrame {
    self.textField.frame = self.bounds;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:self.textField.text.length > 0];
    self.underlineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (void)prepareForInterfaceBuilder {
    self.textField.frame = self.bounds;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:NO];
    self.underlineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(25, 30);
}

#pragma mark - Control Events
- (void)inputDidChange:(UITextField *)textField {
    if (!self.isNeedFloating) {
        return;
    }
    if (textField.text.length > 0) {
        if (![self floatLabelIsShow]) {
            if (self.isNeedAnimation) {
                [UIView animateWithDuration:FloatFadeInDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self floatLabelShow];
                } completion:nil];
            } else {
                [self floatLabelShow];
            }
        }
    } else {
        if ([self floatLabelIsShow]) {
            if (self.isNeedAnimation) {
                [UIView animateWithDuration:FloatFadeOutDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self floatLabelHide];
                } completion:nil];
            } else {
                [self floatLabelHide];
            }
        }
    }
}

#pragma mark - Float Label

- (CGRect)floatLabelRectForRect:(CGRect)rect editing:(BOOL)editing {
    if (editing) {
        return CGRectMake(rect.origin.x, -self.lblFloat.font.lineHeight, rect.size.width, self.lblFloat.font.lineHeight);
    }
    return CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
}

- (void)floatLabelShow {
    self.lblFloat.alpha = 1;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:YES];
}

- (void)floatLabelHide {
    self.lblFloat.alpha = 0;
    self.lblFloat.frame = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:NO];
}

- (BOOL)floatLabelIsShow {
    CGRect showRect = [self floatLabelRectForRect:[self.textField textRectForBounds:self.bounds] editing:YES];
    return CGRectEqualToRect(self.lblFloat.frame, showRect);
}

#pragma mark - Setter & Getter
#pragma mark - Setter
- (void)setNeedUnderLine:(BOOL)needUnderLine {
    _needUnderLine = needUnderLine;
    self.underlineView.hidden = !needUnderLine;
}

- (void)setNeedAnimation:(BOOL)needAnimation {
    _needAnimation = needAnimation;
}

- (void)setNeedFloating:(BOOL)needFloating {
    _needFloating = needFloating;
    self.lblFloat.hidden = !needFloating;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    self.underlineView.backgroundColor = underlineColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    if (_floatText == nil) {
        _floatText = placeholder;
        self.lblFloat.text = _floatText;
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.textField.textAlignment = textAlignment;
    self.lblFloat.textAlignment = textAlignment;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.textField.attributedText = attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.textField.attributedPlaceholder = attributedPlaceholder;
    if (_floatText == nil) {
        _floatText = attributedPlaceholder.string;
        self.lblFloat.text = _floatText;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textField.font = font;
    self.lblFloat.font = [UIFont systemFontOfSize:font.pointSize - 2];
}

- (void)setFloatText:(NSString *)floatText {
    _floatText = floatText;
    self.lblFloat.text = floatText;
}

- (void)setFloatColor:(UIColor *)floatColor {
    _floatColor = floatColor;
    self.lblFloat.textColor = floatColor;
}

- (void)setFloatFont:(UIFont *)floatFont {
    _floatFont = floatFont;
    self.lblFloat.font = floatFont;
}

#pragma mark - Getter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (UILabel *)lblFloat {
    if (!_lblFloat) {
        _lblFloat = [[UILabel alloc] init];
        _lblFloat.font = [UIFont systemFontOfSize:10];
        _lblFloat.alpha = 0;
    }
    return _lblFloat;
}

- (UIView *)underlineView {
    if (!_underlineView) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = [UIColor blackColor];
    }
    return _underlineView;
}

@end

