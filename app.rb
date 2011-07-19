require 'open-uri'

use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:tmp/cache/rack/meta',
  :entitystore => 'file:tmp/cache/rack/body'

Sinatra.register SinatraMore::MarkupPlugin

app_start_time = Time.now

before do
  cache_control :public, :must_revalidate, :max_age => 1.hour
  last_modified app_start_time
end

get '/' do
  @blog_posts = Hash.from_xml(open("http://pipes.yahoo.com/pipes/pipe.run?_id=7d727342ec97cb855c218e5daba3843c&_render=rss").read)["rss"]["channel"]["item"].to_a.map do |feed_item|
    pub_date = DateTime.parse(feed_item["pubDate"]) rescue Time.now
    { :title => feed_item["title"], :date => pub_date, :url => feed_item["link"] }
  end
  last_modified @blog_posts.first[:date] if @blog_posts.first[:date] > app_start_time
  etag @blog_posts.first.hash
  haml :index
end

[:contact, :contributing, :download, :faq, :irc, :screencasts, :examples].each do |page|
  get "/#{page}" do
    haml page
  end
end

get '/consulting' do
  redirect 'http://mojolingo.com/adhearsion-consulting.php'
end

get '/api' do
  redirect 'http://rubydoc.info/github/adhearsion/adhearsion'
end

not_found do
  redirect '/'
end

error do
  redirect '/'
end

def title(page_title, show_title = true)
  content_for(:title) { page_title.to_s }
  @show_title = show_title
end

def show_title?
  @show_title
end
