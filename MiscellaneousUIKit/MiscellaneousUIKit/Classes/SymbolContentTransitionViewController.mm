//
//  SymbolContentTransitionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "SymbolContentTransitionViewController.h"
#import <Symbols/Symbols.h>

@interface SymbolContentTransitionViewController () {
    BOOL _flag;
}
@property (retain, nonatomic, readonly, getter=_button) UIButton *button;
@end

@implementation SymbolContentTransitionViewController
@synthesize button = _button;

- (void)loadView {
    self.view = self.button;
}

- (UIButton *)_button {
    if (auto button = _button) return button;
    
    UIButton *button = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Button";
    configuration.image = [UIImage systemImageNamed:@"apple.intelligence"];
    configuration.symbolContentTransition = [UISymbolContentTransition transitionWithContentTransition:[NSSymbolReplaceContentTransition replaceDownUpTransition] options:[NSSymbolEffectOptions optionsWithRepeating]];
    
    button.configuration = configuration;
    
    [button addTarget:self action:@selector(_buttonDidTrigger:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _button = button;
    return button;
}

- (void)_buttonDidTrigger:(UIButton *)sender {
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Button";
    configuration.image = [UIImage systemImageNamed:_flag ? @"apple.intelligence" : @"apple.writing.tools"];
    configuration.symbolContentTransition = [UISymbolContentTransition transitionWithContentTransition:[NSSymbolReplaceContentTransition replaceDownUpTransition] options:[NSSymbolEffectOptions optionsWithRepeating]];
    sender.configuration = configuration;
    
    _flag = !_flag;
}

@end
