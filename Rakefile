require 'bundler/setup'

desc "Generate dexy documentation and copy to views directory"
task :docs do
  Dir.mkdir 'views/docs' rescue nil
  puts `cd docs && dexy reset && dexy`
  Dir['docs/output/source/**/*.html'].each do |path|
    filename = /docs\/output\/source\/(.*).html/.match(path)[1]
    new_path = "views/docs/#{filename}.html.erb"
    new_dir = new_path.split('/')[0..-2].join('/')
    FileUtils.mkdir_p new_dir
    File.rename path, new_path
  end

  Dir['docs/output/_include/css/*.css'].each do |path|
    filename = /docs\/output\/_include\/css\/(.*).css/.match(path)[1]
    new_path = "public/stylesheets/#{filename}.css"
    File.rename path, new_path
  end
end
