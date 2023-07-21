//
//  SliderViewModifier.swift
//
//
//  Created by Lowell Pence on 6/27/23.
//

import SwiftUI

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

/// Modifies a view by overlaying a thumb control for sliding.
@available(iOS 15, *)
struct SliderViewModifier<Handle: View>: ViewModifier {
    
    @Binding var slider: SliderControl
    let handleView: (SliderControl) -> Handle
    
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 40, minHeight: 40)
            .anchorPreference(key: SliderControl.Track.self, value: .bounds, transform: { $0 })
            .overlayPreferenceValue(SliderControl.Track.self) { anchor in
                SliderHandleView(slider: $slider, trackAnchor: anchor, content: handleView)
            }
    }
}

@available(iOS 15, *)
struct SliderViewModifier_Previews: PreviewProvider {
    struct Preview: View {
        
        @State private var slider: SliderControl
        
        init(axis: Axis) {
            self._slider = State(wrappedValue: SliderControl(axis: axis))
        }
        
        var body: some View {
            VStack {
                Text("Reading: \(slider.currentValue)")
                
                Button("Toggle Axis") {
                    switch slider.axis {
                    case .horizontal:
                        self.slider.axis = .vertical
                    case .vertical:
                        self.slider.axis = .horizontal
                    }
                }
                
                Rectangle()
                    .frame(width: slider.axis == .horizontal ? nil : 10, height: slider.axis == .horizontal ? 10 : nil)
                    .overlaySliderHandle(slider: $slider) { slider in
                        Circle()
                            .foregroundColor(slider.handle.isPressed ? .red : .blue)
                            .frame(width: 30, height: 30)
                            .opacity(0.7)
                    }
            }
        }
    }
    
    static var previews: some View {
        Preview(axis: .horizontal)
            .padding()
    }
}
