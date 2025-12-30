# Custom Active Storage variant transformer for watermarking
Rails.application.config.to_prepare do
  ActiveStorage::Transformers::ImageProcessingTransformer.class_eval do
    private

    # Override operations to support watermark option
    alias_method :original_operations, :operations

    def operations
      ops = original_operations

      if transformations[:watermark]
        # Add watermark as custom MiniMagick operations
        ops = ops.custom do |img|
          img.combine_options do |c|
            c.gravity "SouthEast"
            c.fill "rgba(255,255,255,0.4)"
            c.stroke "rgba(0,0,0,0.2)"
            c.strokewidth "1"
            c.pointsize "18"
            c.annotate "+15+15", "katescuttings.net"
          end
        end
      end

      ops
    end
  end
end
