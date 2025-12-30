# Custom vips operation for watermarking images
require "image_processing/vips"

module ImageProcessing
  module Vips
    class Processor
      # Add watermark text to bottom-right corner
      def watermark(text = nil)
        # Handle watermark: true from Active Storage variants
        text = "katescuttings.net" if text == true || text.nil?
        return image unless text

        # Ensure image has alpha channel for compositing
        img = if image.has_alpha?
                image
              else
                image.bandjoin(255)
              end

        # Ensure image is in sRGB colorspace
        img = img.colourspace(:srgb) if img.interpretation != :srgb

        # Fixed 32pt font for consistent appearance across all image orientations
        # Liberation Serif is metrically compatible with Georgia and available in Docker
        font_size = 32

        text_layer = ::Vips::Image.text(
          text,
          font: "Liberation Serif #{font_size}",
          dpi: 72
        )

        # Create RGBA text with white color and semi-transparency
        white_rgba = img.new_from_image([255, 255, 255, 200])
        text_mask = text_layer.cast(:uchar)

        white_text = white_rgba.copy(interpretation: :srgb)
        text_alpha = white_text.extract_band(3).multiply(text_mask.divide(255.0)).cast(:uchar)
        white_text = white_text.extract_band(0, n: 3).bandjoin(text_alpha)

        # Create shadow for text
        shadow_rgba = img.new_from_image([0, 0, 0, 120])
        shadow_text = shadow_rgba.copy(interpretation: :srgb)
        shadow_text_alpha = shadow_text.extract_band(3).multiply(text_mask.divide(255.0)).cast(:uchar)
        shadow_text = shadow_text.extract_band(0, n: 3).bandjoin(shadow_text_alpha)

        # Position in bottom-right corner with padding
        padding = 15
        x_pos = [img.width - text_layer.width - padding, padding].max
        y_pos = [img.height - text_layer.height - padding, padding].max

        # Composite shadow first, then text
        img = img.composite2(shadow_text, :over, x: x_pos + 1, y: y_pos + 1)
        img.composite2(white_text, :over, x: x_pos, y: y_pos)
      end
    end
  end
end

# Ensure watermark is always applied AFTER resize operations
Rails.application.config.to_prepare do
  ActiveStorage::Transformers::ImageProcessingTransformer.class_eval do
    private

    alias_method :original_operations, :operations

    def operations
      ops = original_operations

      # Find and move watermark operation to the end
      watermark_op = ops.find { |op| op.first.to_s == "watermark" }
      if watermark_op
        ops = ops.reject { |op| op.first.to_s == "watermark" }
        ops = ops + [watermark_op]
      end

      ops
    end
  end
end
