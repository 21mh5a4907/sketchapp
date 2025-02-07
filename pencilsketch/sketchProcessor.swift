import UIKit
import CoreImage

enum SketchEffectType {
    case classic
    case lightShading
    case deepShading
    case fineDetails
}

class SketchProcessor {
    
    static func applyPencilSketch(to image: UIImage, effectType: SketchEffectType = .classic) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            print("❌ Error: Failed to create CIImage from input image")
            return nil
        }

        let context = CIContext()

        // Step 1: Convert to Grayscale (Black & White)
        guard let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono") else {
            print("❌ Error: Failed to create CIPhotoEffectMono filter")
            return nil
        }
        grayscaleFilter.setValue(ciImage, forKey: kCIInputImageKey)

        // Step 2: Blur the Grayscale Image (For Shading)
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            print("❌ Error: Failed to create CIGaussianBlur filter")
            return nil
        }

        let blurRadius: Float
        switch effectType {
        case .classic: blurRadius = 4.0
        case .lightShading: blurRadius = 2.5
        case .deepShading: blurRadius = 6.0
        case .fineDetails: blurRadius = 1.5
        }
        
        blurFilter.setValue(grayscaleFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        // Step 3: Invert the Blurred Image (For Pencil Effect)
        guard let invertFilter = CIFilter(name: "CIColorInvert") else {
            print("❌ Error: Failed to create CIColorInvert filter")
            return nil
        }
        invertFilter.setValue(blurFilter.outputImage, forKey: kCIInputImageKey)

        // Step 4: Blend with Multiply Mode (Lighter Effect)
        guard let blendFilter = CIFilter(name: "CISoftLightBlendMode") else {
            print("❌ Error: Failed to create CISoftLightBlendMode filter")
            return nil
        }
        blendFilter.setValue(grayscaleFilter.outputImage, forKey: kCIInputImageKey)
        blendFilter.setValue(invertFilter.outputImage, forKey: kCIInputBackgroundImageKey)

        // Step 5: Increase Brightness (Reduce Darkness)
        guard let brightnessFilter = CIFilter(name: "CIColorControls") else {
            print("❌ Error: Failed to create CIColorControls filter")
            return nil
        }
        brightnessFilter.setValue(blendFilter.outputImage, forKey: kCIInputImageKey)
        brightnessFilter.setValue(0.2, forKey: kCIInputBrightnessKey) // Adjust brightness

        // Step 6: Apply Line Overlay (For Pencil Strokes)
        guard let lineOverlayFilter = CIFilter(name: "CILineOverlay") else {
            print("❌ Error: Failed to create CILineOverlay filter")
            return nil
        }
        lineOverlayFilter.setValue(brightnessFilter.outputImage, forKey: kCIInputImageKey)

        // Generate Final Image
        if let outputImage = lineOverlayFilter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            print("✅ High-Quality Pencil Sketch (Lighter Effect) Applied Successfully!")
            return UIImage(cgImage: cgImage)
        } else {
            print("❌ Error: Failed to generate final image")
        }

        return nil
    }
}
