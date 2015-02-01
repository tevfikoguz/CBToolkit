//
//  CBViews.swift
//  CBToolkit
//
//  Created by Wes Byrne on 10/22/14.
//  Copyright (c) 2014 WCBMedia. All rights reserved.
//

import Foundation
import UIKit




@IBDesignable public class CBView: UIView {
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
    @IBInspectable public var borderColor: UIColor = UIColor.lightGrayColor() {
        didSet { self.layer.borderColor = borderColor.CGColor }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
}




@IBDesignable public class CBShadowView: UIView {
    
    
    @IBInspectable public var shadowColor: UIColor = UIColor.blackColor() {
        didSet { self.layer.shadowColor = shadowColor.CGColor }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet { self.layer.shadowRadius = shadowRadius }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0 {
        didSet { self.layer.shadowOpacity = shadowOpacity }
    }
    @IBInspectable public var shadowOffset: CGSize = CGSizeZero {
        didSet { self.layer.shadowOffset = shadowOffset }
    }
    
    @IBInspectable public var shouldRasterize: Bool = false {
        didSet {
            self.layer.shouldRasterize = shouldRasterize
            self.layer.rasterizationScale = UIScreen.mainScreen().scale
        }
    }
    
    @IBInspectable public var useShadowPath: Bool = false
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
    @IBInspectable public var borderColor: UIColor = UIColor.lightGrayColor() {
        didSet { self.layer.borderColor = borderColor.CGColor }
    }
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = shadowColor.CGColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if useShadowPath {
            self.layer.shadowPath = UIBezierPath(rect: self.frame).CGPath
        }
    }
}









@IBDesignable public class CBBorderView: UIView {
    
    @IBInspectable public var topBorder: Bool = false
    @IBInspectable public var bottomBorder: Bool = false
    @IBInspectable public var leftBorder: Bool = false
    @IBInspectable public var rightBorder: Bool = false
    
    @IBInspectable public var leftInset: CGFloat = 0
    @IBInspectable public var rightInset: CGFloat = 0
    @IBInspectable public var topInset: CGFloat = 0
    @IBInspectable public var bottomInset: CGFloat = 0
    
    @IBInspectable public var borderWidth: CGFloat = 1
    @IBInspectable public var borderColor: UIColor = UIColor.whiteColor()

    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, CGFloat(borderWidth));
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        
        if topBorder == true {
            CGContextMoveToPoint(context, leftInset, 0);
            CGContextAddLineToPoint(context, self.bounds.size.width - rightInset, 0);
            CGContextStrokePath(context);
        }
        if leftBorder == true {
            CGContextMoveToPoint(context, 0, topInset);
            CGContextAddLineToPoint(context, 0, self.frame.size.height - bottomInset);
            CGContextStrokePath(context);
        }
        if rightBorder == true {
            CGContextMoveToPoint(context, self.frame.size.width, topInset);
            CGContextAddLineToPoint(context, self.bounds.size.width, self.frame.size.height - bottomInset);
            CGContextStrokePath(context);
        }
        if bottomBorder == true {
            CGContextMoveToPoint(context, leftInset, self.frame.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width - rightInset, self.frame.size.height);
            CGContextStrokePath(context);
        }
    }
}





@IBDesignable public class CBGradientView: CBBorderView {
    
    @IBInspectable public var topColor: UIColor! = UIColor(white: 0, alpha: 1)
    @IBInspectable public var middleColor: UIColor?
    @IBInspectable public var bottomColor: UIColor! = UIColor(white: 0.2, alpha: 1)
    
    @IBInspectable public var topLocation: CGFloat = 0
    @IBInspectable public var middleLocation: CGFloat = 0.5
    @IBInspectable public var bottomLocation: CGFloat = 1
    
     override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext();
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        var locations: [CGFloat]!
        var colors: [UIColor]!
        
        if (middleColor == nil) {
            locations = [topLocation, bottomLocation];
            colors = [topColor, bottomColor];
        }
        else {
            locations = [topLocation, middleLocation, bottomLocation];
            colors = [topColor, middleColor!, bottomColor];
        }
        
        let gradientColors = colors.map {(color: UIColor!) -> AnyObject! in return color.CGColor as AnyObject! } as NSArray
        let gradient = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
        
        var startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        var endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextSaveGState(context);
        CGContextAddRect(context, rect);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
        
        
    }
}













