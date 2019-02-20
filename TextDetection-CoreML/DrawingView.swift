//
//  DrawingView.swift
//  TextDetection-CoreML
//
//  Created by GwakDoyoung on 21/02/2019.
//  Copyright © 2019 tucan9389. All rights reserved.
//

import UIKit
import Vision

class DrawingView: UIView {


    public var regions: [VNTextObservation?]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.clear(rect);
        guard let regions = regions else { return }
        
        let frameSize = self.bounds.size
        
        for region in regions {
            if let boxes = region?.characterBoxes {
                for box in boxes {
                    let points = [
                        box.topLeft,
                        box.topRight,
                        box.bottomRight,
                        box.bottomLeft
                    ].map({ CGPoint(x: $0.x, y: 1-$0.y)*frameSize })
                    drawPolygon(ctx: ctx, points: points,
                                color: UIColor(red: 1, green: 0, blue: 0, alpha: 0.6).cgColor)
                }
                var points = (boxes.compactMap{ [$0.topLeft, $0.topRight] } + boxes.reversed().compactMap{ [$0.bottomRight, $0.bottomLeft] }).reduce([], +)
                points = points.map({ CGPoint(x: $0.x, y: 1-$0.y)*frameSize })
                drawPolygon(ctx: ctx, points: points,
                            color: UIColor(red: 0, green: 1, blue: 0, alpha: 0.3).cgColor,
                            fill: true)
            }
        }
    }
    
    private func drawLine(ctx: CGContext, from p1: CGPoint, to p2: CGPoint, color: CGColor) {
        ctx.setStrokeColor(color)
        ctx.setLineWidth(1.0)
        
        ctx.move(to: p1)
        ctx.addLine(to: p2)
        
        ctx.strokePath();
    }
    
    private func drawPolygon(ctx: CGContext, points: [CGPoint], color: CGColor, fill: Bool = false) {
        if fill {
            ctx.setStrokeColor(UIColor.clear.cgColor)
            ctx.setFillColor(color)
            ctx.setLineWidth(0.0)
        } else {
            ctx.setStrokeColor(color)
            ctx.setLineWidth(1.0)
        }
        
        
        for i in 0..<points.count {
            if i == 0 {
                ctx.move(to: points[i])
            } else {
                ctx.addLine(to: points[i])
            }
        }
        if let firstPoint = points.first {
            ctx.addLine(to: firstPoint)
        }
        
        if fill {
            ctx.fillPath()
        } else {
            ctx.strokePath();
        }
    }
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func * (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}
