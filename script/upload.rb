ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 's3_uploader'

def upload(source, dryrun)
  bucket = 'github-vs'
  path = 'unity'

  abort("Tell me what to upload (git, build or feed)") unless source == 'git' || source == 'build' || source == 'feed'
  puts "Doing a dry run because you didn't tell me to 'go'" if dryrun

  source = "#{File.dirname(ENV['BUNDLE_GEMFILE'])}/#{source}/unity"

  max_age = ENV['AWS_S3_CACHE_CONTROL_MAX_AGE'] || '300'

  options = {
    :region => 'us-east-1',
    :destination_dir => path,
    :public => true,
    :s3_key => ENV['AWS_S3_ACCESS_KEY_ID'],
    :s3_secret => ENV['AWS_S3_SECRET_ACCESS_KEY'],
    :metadata => {
      #'Cache-Control' => "max-age=#{max_age}",
      'Cache-Control' => "no-cache",
    },
    :file_metadata => {}
  }

  content_types = { ".json" => 'application/json', "" => 'application/octet-stream' }.freeze
  content_disps = { ".json" => 'inline', "" => 'attachment' }.freeze

  puts "Going into #{source}"

  Dir.chdir "#{source}" do
    Dir["**/*"].select { |f|
      next if File.directory? f

      ext = File.extname f
      type = content_types[ext] || content_types[""]
      disp = content_disps[ext] || content_disps[""]

      options[:file_metadata] = options[:file_metadata].merge({
        f => {
          'Content-Type' => type,
          'Content-Disposition' => "#{disp}; filename=#{f}",
        }
      })
    }

    S3Uploader.upload_directory('.', bucket, options) unless dryrun
  end

  options[:file_metadata].each do |key, value|
    msg = "https://ghfvs-installer.github.com/#{path}/#{key} => #{value}"
    puts "Would upload #{msg}" if dryrun
    puts "Would upload #{msg}" unless dryrun
  end
end