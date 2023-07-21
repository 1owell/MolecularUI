//
//  SliderHandleView.swift
//
//
//  Created by Lowell Pence on 7/20/23.
//

import SwiftUI

struct SliderHandleView<Content: View>: View {
    
    @Binding var slider: SliderControl
    let trackAnchor: Anchor<CGRect>?
    let content: (SliderControl) -> Content
    
    @GestureState private var isDragging = false
    
    var body: some View {
        GeometryReader { proxy in
            if let trackAnchor {
                let sliderTrack = proxy[trackAnchor]
                let position = slider.handlePosition(in: proxy, trackSize: sliderTrack)
                
                content(slider)
                    .anchorPreference(key: SliderControl.Handle.self, value: .bounds, transform: { anchor in
                        SliderControl.Handle(anchor: anchor)
                    })
                    .position(position)
                    .gesture(dragGesture(on: sliderTrack, proxy: proxy))
                    .frame(minWidth: 100, minHeight: 100)
            }
        }
        .onPreferenceChange(SliderControl.Handle.self) { handle in
            slider.handle.anchor = handle.anchor
        }
        .onChange(of: isDragging) { isPressed in
            slider.handle.isPressed = isPressed
        }
    }
    
    func dragGesture(on track: CGRect, proxy: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { drag in
                guard let handle = slider.handle.anchor else { return }
                
                slider.currentValue = slider.calculateSliderReading(
                    from: drag.location,
                    trackBounds: track,
                    handleBounds: proxy[handle]
                )
            }
    }
}
