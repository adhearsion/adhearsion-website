# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5b993ddc06f5bcbbc7832668306e59c1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  
  def load_blog_posts_from_wiki
    WIKI.getBlogEntries("adhearsion").map do |blog_entry|
      normalized = {}
      normalized[:title], normalized[:url] = blog_entry.values_at "title", "url"
      normalized[:date] = blog_entry["publishDate"].to_date
      normalized[:content] = WIKI.getBlogEntry(blog_entry["id"])["content"]
      normalized
    end
  rescue => error
    p error
    [{
      :title => "Sorry, we're having some technical difficulties",
      :date => Time.now,
      :url  => "http://adhearsion.com",
      :content => "The app that runs this site dynamically fetches the blog posts for this page from our wiki, but it seems the wiki is down at the moment. Sorry for the inconvenience."
    }]
  end
end
