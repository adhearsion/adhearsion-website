require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'

Sinatra.register SinatraMore::MarkupPlugin

app_start_time = Time.now

before do
  cache_control :public, :must_revalidate, :max_age => 1.hour
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

[:contact, :features, :contributing, :download, :faq, :irc, :screencasts, :examples, :punchblock, :ahnconf2011, :ahnconf_live].each do |page|
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

get '/contribute' do
  redirect 'https://github.com/adhearsion/adhearsion/wiki/Contributing'
end

get '/docs' do
  render_docs_page
end

get '/docs/:page' do
  render_docs_page params[:page]
end

def render_docs_page(page = 'index')
  erb :"docs/#{page}.html", :layout_engine => :haml
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
