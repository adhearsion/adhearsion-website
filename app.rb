require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'

Sinatra.register SinatraMore::MarkupPlugin

app_start_time = Time.now

before do
  cache_control :public, :must_revalidate, :max_age => 1.hour if ENV['RACK_ENV']
end

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key     = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret  = ENV["TWITTER_CONSUMER_SECRET"]
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
    !@posts || @posts.empty? || expired?
  end

  def hash
    posts.first.hash
  end

  def first_post_date
    first_post = posts.first
    first_post && first_post[:date]
  end

  def rss_url
    @rss_url ||= "http://pipes.yahoo.com/pipes/pipe.run?_id=7d727342ec97cb855c218e5daba3843c&_render=rss"
  end
end

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, lexer: language)
  end
end

Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, 'markdown', 'mkd', 'md'

set :markdown, renderer: HTMLwithPygments.new(with_toc_data: true), fenced_code_blocks: true

get '/' do
  @blog_posts = BlogPostAggregator.instance.posts
  if ENV['RACK_ENV']
    last_modified [app_start_time, BlogPostAggregator.instance.first_post_date].max
    etag BlogPostAggregator.instance.hash
  end
  haml :index
end

get '/conference*' do
  redirect 'http://adhearsionconf.com'
end

get '/examples' do
  redirect '/docs/call-controllers'
end

%w{community get-help faq irc media foundation cloud support gsoc}.each do |page|
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
  '/api'          => 'http://rubydoc.info/gems/adhearsion/frames',
  '/wiki'         => 'https://github.com/adhearsion/adhearsion/wiki',
  '/contributing' => '/docs/contributing',
  '/rss'          => BlogPostAggregator.instance.rss_url,
  '/download'     => '/docs/getting-started/installation',
  '/blather'      => 'http://adhearsion.github.com/blather'
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
  toc = markdown :"docs/#{page}", renderer: Redcarpet::Render::HTML_TOC
  docs = markdown :"docs/#{page}"

  toc.sub! /\n<\/li>\n<\/ul>\n$/, ''
  toc.sub! /^<ul>\n<li>\n<a href=\"#toc_0\">.*<\/a>\n/, ''

  haml :docs, locals: {docs: docs.sub('[TOC]', toc)}
end

def title(page_title, show_title = true)
  content_for(:title) { page_title.to_s }
  @show_title = show_title
end

def show_title?
  @show_title
end

def tweets
  $twitter.user_timeline('adhearsion', count: 2)
end
