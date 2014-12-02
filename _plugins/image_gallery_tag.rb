# Jonas Genannt <jonas@brachium-system.net>
require 'RMagick'
include Magick

module Jekyll
  class ImageGalleryTag < Liquid::Tag
    def initialize(tag_name, config, tokens)
      super
      @config = config.strip
    end

    def render(context)
      site = context.registers[:site]
      gallery_directory = File.join(site.source, @config)
      unless File.directory?(gallery_directory)
        raise "Gallery directory #{gallery_directory} not found"
      end
      images = Array.new
      Dir.entries(gallery_directory).each do |filename|
        next if filename !~ /\.(jpg|jpeg)/i
        next if filename =~ /_thumb\./
        filename_thumb = gen_thumb_name(filename)
        gen_thumb_image(gallery_directory, filename, filename_thumb)
        images << '<a class="image-link" href="/' + File.join(@config, filename) + '" data-lightbox="' + @config + '"><img class="image-thumb" src="/' + File.join(@config, filename_thumb) + '"/></a>'
      end
      '<div class="image-row"><div class="image-set">' + images.join + '</div></div>'
    end

    def gen_thumb_name(filename)
      name = filename.split(/\./, 2)
      name[0] + "_thumb." + name[1]
    end

    def gen_thumb_image(gallery_directory, filename, thumb_filename)
      # generate thumb only if it does not exists
      size = 300
      geom = "#{size}x#{size}"
      unless File.exists?(File.join(gallery_directory,thumb_filename))
        img = Image.read(File.join(gallery_directory, filename))[0]
        img.change_geometry!(geom) { |cols, rows| img.thumbnail! cols, rows }
        img.write(File.join(gallery_directory,thumb_filename)) { self.quality = 80 }
      end
    end
  end
end

Liquid::Template.register_tag('imagegallery', Jekyll::ImageGalleryTag)
