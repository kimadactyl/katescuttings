# Custom vips operation for watermarking images
require "image_processing/vips"

module ImageProcessing
  module Vips
    class Processor
      # Add watermark text to bottom-right corner
      def watermark(text = "katescuttings.net")
        return image unless text

        # Ensure image has alpha channel for compositing
        img = if image.has_alpha?
                image
              else
                image.bandjoin(255)
              end

        # Ensure image is in sRGB colorspace
        img = img.colourspace(:srgb) if img.interpretation != :srgb

        # Create text overlay
        text_layer = ::Vips::Image.text(
          text,
          font: "sans bold 16",
          dpi: 150
        )

        # Create RGBA text with white color and semi-transparency
        # text_layer is a single-band image (grayscale text mask)
        # We need to create a 4-band RGBA image
        white_rgba = img.new_from_image([255, 255, 255, 180])
        text_mask = text_layer.cast(:uchar)

        # Use the text as alpha channel for the white color
        white_text = white_rgba.copy(interpretation: :srgb)
        # Scale the alpha by the text mask
        alpha_scaled = white_text.extract_band(3).multiply(text_mask.divide(255.0)).cast(:uchar)
        white_text = white_text.extract_band(0, n: 3).bandjoin(alpha_scaled)

        # Create shadow layer (dark text offset by 1 pixel)
        shadow_rgba = img.new_from_image([0, 0, 0, 100])
        shadow = shadow_rgba.copy(interpretation: :srgb)
        shadow_alpha = shadow.extract_band(3).multiply(text_mask.divide(255.0)).cast(:uchar)
        shadow = shadow.extract_band(0, n: 3).bandjoin(shadow_alpha)

        # Position in bottom-right corner with padding
        padding = 15
        x_pos = [img.width - text_layer.width - padding, padding].max
        y_pos = [img.height - text_layer.height - padding, padding].max

        # Composite shadow slightly offset, then text on top
        img = img.composite2(shadow, :over, x: x_pos + 1, y: y_pos + 1)
        img.composite2(white_text, :over, x: x_pos, y: y_pos)
      end
    end
  end
end
