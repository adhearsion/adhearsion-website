require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'

Sinatra.register SinatraMore::MarkupPlugin

app_start_time = Time.now

before do
  # cache_control :public, :must_revalidate, :max_age => 1.hour
end

require 'singleton'

class BlogPostAggregator
  include Singleton

  attr_reader :last_fetch

  def posts
    fetch? ? fetch : @posts
  end

  def fetch
    @last_fetch = Time.now
    @posts = Hash.from_xml(open("http://pipes.yahoo.com/pipes/pipe.run?_id=7d727342ec97cb855c218e5daba3843c&_render=rss").read)["rss"]["channel"]["item"].to_a.map do |feed_item|
      pub_date = DateTime.parse(feed_item["pubDate"]) rescue Time.now
      { :title => feed_item["title"], :date => pub_date, :url => feed_item["link"], :description => feed_item["description"] }
    end
  end

  def expired?
    Time.now > last_fetch + 1.hour
  end

  def fetch?
    !@posts || expired?
  end

  def hash
    posts.first.hash
  end
end

get '/' do
  @blog_posts = BlogPostAggregator.instance.posts
  # last_modified [app_start_time, BlogPostAggregator.instance.posts.first[:date]].max
  # etag BlogPostAggregator.instance.hash
  haml :index
end

%w{community get-help conference faq irc}.each do |page|
  get "/#{page}" do
    haml page.to_sym
  end
end

post '/get-help' do
  @contact_status = 'error'
  haml :'get-help'
end

get '/api' do
  redirect 'http://rubydoc.info/github/adhearsion/adhearsion'
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

def title(page_title, show_title = true)
  content_for(:title) { page_title.to_s }
  @show_title = show_title
end

def show_title?
  @show_title
end
