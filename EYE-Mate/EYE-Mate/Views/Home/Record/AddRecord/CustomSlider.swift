//
//  CustomSlider.swift
//  EYE-Mate
//
//  Created by seongjun on 2/5/24.
//

import SwiftUI

struct CustomSlider: UIViewRepresentable {
    final class Coordinator: NSObject {
        // @State 변수 값에 대한 참조를 받음
        var value: Binding<Float>

        init(value: Binding<Float>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            let roundedValue = Double(round(sender.value * 10) / 10)
            let roundedValueString = String(format: "%.1f", roundedValue)
            sender.value = Float(roundedValueString)!
            self.value.wrappedValue = Float(roundedValueString)!
        }
    }

    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?

    @Binding var value: Float

    private func thumbImage() -> UIImage {
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        thumbView.backgroundColor = thumbColor
        thumbView.layer.borderWidth = 2
        thumbView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)

        return renderer.image { context in
            thumbView.layer.render(in: context.cgContext)
        }
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        let image = thumbImage()

        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.maximumValue = 2.0
        slider.minimumValue = 0.0
        slider.value = Float(String(format: "%.1f", value))!
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        slider.setThumbImage(image, for: .normal)
        slider.setThumbImage(image, for: .highlighted)

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // UIView와 SwiftUI 사이에 데이터 Coordinating
        uiView.value = Float(self.value)
    }

    func makeCoordinator() -> CustomSlider.Coordinator {
        Coordinator(value: $value)
    }
}

#Preview {
    CustomSlider(
        thumbColor: .white,
        minTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 1),
        maxTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 0.2),
        value: .constant(0.5)
    )
}
