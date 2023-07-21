//
//  View+SliderModifier.swift
//
//
//  Created by Lowell Pence on 7/20/23.
//

import SwiftUI

public extension View {
    /// Overlays a slider "track" view with a given handle view, to provide a slider control. Does *not* handle
    /// accessibility for you.
    /// - Parameters:
    ///  - slider: A binding to slider control state data.
    ///  - handleView: A view builder closure to provide the thumb control view to overlay the track with. Must have a
    ///  defined frame.
    @available(iOS 15, *)
    func overlaySliderHandle<Handle: View>(
        slider: Binding<SliderControl>,
        @ViewBuilder _ handleView: @escaping (SliderControl) -> Handle
    ) -> some View {
        modifier(SliderViewModifier(slider: slider, handleView: handleView))
    }
}
