//
//  SliderControl.swift
//
//
//  Created by Lowell Pence on 7/20/23.
//

import SwiftUI

public struct SliderControl {
    var axis: Axis = .horizontal
    var currentValue: Double = 0.0
    var handle = Handle()
        
    /// Calculates the position of the slider handle for the current value of the slider.
    /// - Parameters:
    ///   - proxy: The geometry proxy to use for retrieving the bounds of the slider handle
    ///   - trackSize: The bounds of the slider track
    /// - Returns: The point at which the center of the slider handle should be at. For horizontal sliders,
    /// the handle will be at the left edge when the current value is 0. For vertical, it will be at the bottom.
    func handlePosition(in proxy: GeometryProxy, trackSize: CGRect) -> CGPoint {
        guard let anchor = handle.anchor else { return CGPoint() }
        
        let handleSize = proxy[anchor]
        let x = horizontalHandlePosition(trackSize: trackSize, handleSize: handleSize)
        let y = verticalHandlePosition(trackSize: trackSize, handleSize: handleSize)
        return CGPoint(x: x, y: y)
    }
    
    /// Calculates what the current value of the slider should be set to from the given drag location.
    /// - Parameters:
    ///   - drag: The location of the drag gesture within the slider track's frame.
    ///   - trackBounds: The bounds of the slider track view.
    ///   - handleBounds: The bounds of the slider handle view.
    /// - Returns: The current value of the slider, clamped to be between 0 and 1.
    func calculateSliderReading(from drag: CGPoint, trackBounds: CGRect, handleBounds: CGRect) -> Double {
        let handleSize = axis == .horizontal ? handleBounds.width : handleBounds.height
        let halfHandleSize = handleSize / 2
        let drag = axis == .horizontal ? drag.x : (trackBounds.height - drag.y)
        let dragPosition = drag <= halfHandleSize ? 0 : drag - halfHandleSize
        let dragRange = (axis == .horizontal ? trackBounds.width : trackBounds.height) - handleSize
        return (dragPosition / dragRange).clamped(to: 0...1)
    }
    
    private func horizontalHandlePosition(trackSize: CGRect, handleSize: CGRect) -> Double {
        guard axis == .horizontal else { return trackSize.midX }
        
        return currentValue * (trackSize.width - handleSize.width) + (handleSize.width / 2)
    }
    
    private func verticalHandlePosition(trackSize: CGRect, handleSize: CGRect) -> Double {
        guard axis == .vertical else { return trackSize.midY }
        
        let trackHeight = trackSize.height
        let handleHeight = handleSize.height
        let halfHandleHeight = handleHeight / 2
        let modifier = trackHeight - handleHeight
        
        return (((currentValue - 1) * modifier) / -1) + halfHandleHeight
    }
    
    struct Handle: Equatable, PreferenceKey {
        var anchor: Anchor<CGRect>?
        var isPressed = false
        
        func frame(in proxy: GeometryProxy) -> CGRect {
            guard let anchor else { return .zero }
            
            return proxy[anchor]
        }
    
        static var defaultValue = Handle()
        
        static func reduce(value: inout Handle, nextValue: () -> Handle) {
            value = nextValue()
        }
    }
    
    struct Track: PreferenceKey {
        static var defaultValue: Anchor<CGRect>?
        
        static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
            value = nextValue()
        }
    }
}
