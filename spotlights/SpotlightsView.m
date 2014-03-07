    // SpotlightsView.m

    #import "SpotlightsView.h"
    #import <QuartzCore/QuartzCore.h>
    #import <objc/runtime.h>

    @implementation SpotlightsView {
        UIImageView *_dimImageView;
        UIImageView *_brightImageView;
        CAShapeLayer *_mask;
        NSMutableArray *_spotlightPaths;
    }

    #pragma mark - Public API

    - (void)setImage:(UIImage *)image {
        _dimImageView.image = image;
        _brightImageView.image = image;
    }

    - (UIImage *)image {
        return _dimImageView.image;
    }

    - (void)addDraggableSpotlightWithCenter:(CGPoint)center radius:(CGFloat)radius {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius)];
        [_spotlightPaths addObject:path];
        [self setNeedsLayout];
    }

    #pragma mark - UIView overrides

    - (instancetype)initWithFrame:(CGRect)frame
    {
        if (self = [super initWithFrame:frame]) {
            [self commonInit];
        }
        return self;
    }

    - (instancetype)initWithCoder:(NSCoder *)aDecoder {
        if (self = [super initWithCoder:aDecoder]) {
            [self commonInit];
        }
        return self;
    }

    - (void)layoutSubviews {
        [super layoutSubviews];
        [self layoutDimImageView];
        [self layoutBrightImageView];
    }

    #pragma mark - UIResponder overrides

    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        for (UITouch *touch in touches){
            [self touchBegan:touch];
        }
    }

    - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        for (UITouch *touch in touches){
            [self touchMoved:touch];
        }
    }

    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        for (UITouch *touch in touches) {
            [self touchEnded:touch];
        }
    }

    - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
        for (UITouch *touch in touches) {
            [self touchEnded:touch];
        }
    }

    #pragma mark - Implementation details - appearance/layout

    - (void)commonInit {
        self.backgroundColor = [UIColor blackColor];
        self.multipleTouchEnabled = YES;
        [self initDimImageView];
        [self initBrightImageView];
        _spotlightPaths = [NSMutableArray array];
    }

    - (void)initDimImageView {
        _dimImageView = [self newImageSubview];
        _dimImageView.alpha = 0.5;
    }

    - (void)initBrightImageView {
        _brightImageView = [self newImageSubview];
        _mask = [CAShapeLayer layer];
        _brightImageView.layer.mask = _mask;
    }

    - (UIImageView *)newImageSubview {
        UIImageView *subview = [[UIImageView alloc] init];
        subview.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:subview];
        return subview;
    }

    - (void)layoutDimImageView {
        _dimImageView.frame = self.bounds;
    }

    - (void)layoutBrightImageView {
        _brightImageView.frame = self.bounds;
        UIBezierPath *unionPath = [UIBezierPath bezierPath];
        for (UIBezierPath *path in _spotlightPaths) {
            [unionPath appendPath:path];
        }
        _mask.path = unionPath.CGPath;
    }

    #pragma mark - Implementation details - touch handling

    static char kSpotlightPathAssociatedObjectKey;

    - (void)touchBegan:(UITouch *)touch {
        UIBezierPath *path = [self firstSpotlightPathContainingTouch:touch];
        if (path == nil)
            return;
        objc_setAssociatedObject(touch, &kSpotlightPathAssociatedObjectKey,
            path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    - (void)touchMoved:(UITouch *)touch {
        UIBezierPath *path = objc_getAssociatedObject(touch,
            &kSpotlightPathAssociatedObjectKey);
        if (path == nil)
            return;
        CGPoint point = [touch locationInView:self];
        CGPoint priorPoint = [touch previousLocationInView:self];
        [path applyTransform:CGAffineTransformMakeTranslation(
            point.x - priorPoint.x, point.y - priorPoint.y)];
        [self setNeedsLayout];
    }

    - (void)touchEnded:(UITouch *)touch {
        // Nothing to do
    }

    - (UIBezierPath *)firstSpotlightPathContainingTouch:(UITouch *)touch {
        CGPoint point = [touch locationInView:self];
        for (UIBezierPath *path in _spotlightPaths) {
            if ([path containsPoint:point])
                return path;
        }
        return nil;
    }

    @end
