module Paperclip
  class Backgroundize < Processor
    def initialize(file, options = {}, attachment = nil)
      @file           = file
      @current_format = File.extname(@file.path)
      @basename       = File.basename(@file.path, @current_format)
      @format = 'jpg'
      @is_enabled = options[:background]
      @size = options[:geometry].sub('#', '')

      @options = options
    end

    def make
      src = @file

      if !@is_enabled
        dst = create_temp_image(@basename)
        convert(":source :dest",
          source: File.expand_path(src.path),
          dest: File.expand_path(dst.path)
        )
        return dst
      end

      # Add color overlay to image
      solid = create_temp_image("solid", "png")

      convert("-size #{@size} xc:rgba\\(237,226,198,0.6\\) :dest",
        dest: File.expand_path(solid.path)
      )

      lightened_image = Tempfile.new(["lightened", ".jpg"])

      Paperclip.run('composite', 
        "-compose Screen -gravity center :change :base :output", 
        change: File.expand_path(solid.path), 
        base: File.expand_path(src.path), 
        output: File.expand_path(lightened_image.path)
      )

      # Blend image with bloom
      bloom_path = Rails.root.join("lib", "paperclip_processors", "bloom.jpg")

      bloomed_image = create_temp_image("bloomed")
      Paperclip.run('composite', 
        "-compose Screen -gravity center :change :base :output", 
        change: File.expand_path(bloom_path), 
        base: File.expand_path(lightened_image.path), 
        output: File.expand_path(bloomed_image.path)
      )

      compressed_image = create_temp_image("#{@basename}_compressed")
      convert(
        "-strip -interlace Plane -quality 70% :source :dest",
        source: File.expand_path(bloomed_image.path),
        dest: File.expand_path(compressed_image.path)
      )

      compressed_image
    end

    protected

    def create_temp_image(name, extension="jpg")
      file = Tempfile.new([name, ".#{extension}"])    
      file.binmode
      file
    end
  end
end