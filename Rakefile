require 'rake'
require 'rmagick'
include Magick

desc 'build page'
task :build do
  puts %x{jekyll build}
end

GENERATED_BLOG='/home/jonas/entwicklung/generated_hggh.github.io/'

desc 'sync build page to directory for commit and upload'
task :sync do
  unless File.directory?(GENERATED_BLOG)
    raise "Could not access generated blog at #{GENERATED_BLOG}"
  end
  puts %x{rsync -av --delete --exclude CNAME --exclude .git _site/ #{GENERATED_BLOG}}
end

desc 'resize orginal pics'
task :resize do
  if !ARGV[1]
    raise "please add directory"
  end
  if File.directory?(ARGV[1])
    Dir.entries(ARGV[1]).each do |filename|
      next if filename !~ /\.(jpg|jpeg)/i
      next if filename =~ /_thumb\./
      image_file = File.join(ARGV[1], filename)

      puts "Doing ... #{image_file}"
      img = Image.read(image_file)[0]
      img = img.scale(0.5)
      img.write(image_file) { self.quality = 85 }
    end
  else
    raise "Could not find directory: " + ARGV[1]
  end
end
