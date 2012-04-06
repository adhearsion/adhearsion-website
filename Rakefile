desc "Copy dexy documentation to views directory"
task :docs do
  puts 'You should run `cd docs && dexy` to re-generate the docs first'

  Dir.mkdir 'views/docs' rescue nil
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
