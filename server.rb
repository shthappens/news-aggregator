require "sinatra"
require "pry"
require "csv"

set :bind, '0.0.0.0'  # bind to all interfaces

get "/" do
  @articles = CSV.readlines("articles.csv")
  erb :index
end

get "/articles" do
  @articles = CSV.readlines("articles.csv")
  erb :index
end

get "/articles/new" do
  erb :article_new
end

post "/articles/new" do

  if url_check(params[:article_url])
    @error_message = "Duplicate URL. This article already exists. Please submit another."
    erb :article_new
  else
    CSV.open("articles.csv", "a+") do |csv|
      csv << [params[:article_title], params[:article_url], params[:article_desc]]
    end
    redirect "/articles"
  end

end

def url_check(params_url)
  url_check = []
  CSV.foreach("articles.csv") do |entry|
    url_check.push(entry[1])
  end
  url_check.any? { |url| url == params_url }
end
