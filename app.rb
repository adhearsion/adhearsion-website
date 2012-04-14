require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'

Sinatra.register SinatraMore::MarkupPlugin

app_start_time = Time.now

before do
  cache_control :public, :must_revalidate, :max_age => 1.hour if ENV['RACK_ENV']
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
    @posts = Hash.from_xml(open(rss_url).read)["rss"]["channel"]["item"].to_a.map do |feed_item|
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

  def rss_url
    @rss_url ||= "http://pipes.yahoo.com/pipes/pipe.run?_id=7d727342ec97cb855c218e5daba3843c&_render=rss"
  end
end

get '/' do
  @blog_posts = BlogPostAggregator.instance.posts
  if ENV['RACK_ENV']
    last_modified [app_start_time, BlogPostAggregator.instance.posts.first[:date]].max
    etag BlogPostAggregator.instance.hash
  end
  haml :index
end

%w{community get-help conference faq irc media}.each do |page|
  get "/#{page}" do
    haml page.to_sym
  end
end

post '/get-help' do
  @has_errors = []
  @has_errors << "Name can not be blank." if params[:yourName].empty?
  @has_errors << "Email is empty or invalid." unless params[:email].match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)
  @has_errors << "Please fill in your inquiry." if params[:query].empty?
  if @has_errors.empty?
    Pony.mail({
      :to => 'hello@mojolingo.com',
      :subject => 'Adhearsion Contact Request',
      :body => "Message from #{params[:yourName]} - #{params[:email]}\n\n#{params[:query]}",
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => ENV['GMAIL_USERNAME'],
        :password             => ENV['GMAIL_PASSWORD'],
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => "adhearsion.com" # the HELO domain provided by the client to the server
      }
    })
    @contact_status = 'success'
  else
    @your_name = params[:yourName]
    @your_email = params[:email]
    @your_query = params[:query]
    @contact_status = 'error'
  end
  haml :'get-help'
end

{
  '/api'          => 'http://rubydoc.info/github/adhearsion/adhearsion/file/README.markdown',
  '/wiki'         => 'https://github.com/adhearsion/adhearsion/wiki',
  '/contributing' => 'https://github.com/adhearsion/adhearsion/wiki/Contributing',
  '/rss'          => BlogPostAggregator.instance.rss_url
}.each_pair do |local, remote|
  get local do
    redirect remote
  end
end

get '/docs' do
  render_docs_page
end

get '/docs/*' do |page|
  render_docs_page page
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
