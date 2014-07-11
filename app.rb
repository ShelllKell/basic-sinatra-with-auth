require "sinatra"
require "rack-flash"

require "./lib/user_database"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @user_database = UserDatabase.new
  end

  get "/" do
    erb :root
  end

  get "/register" do
    erb :register
  end

  get "/login" do
    @user = @user_database.find(session[:user_id])[:username]
    erb :login, :locals => {:user => @user}
  end

  get "/error" do
    erb :error
  end

  post "/login" do

    #we run find_user and give an error if the login info doesn't exist in our database
    user = find_user
    redirect "/error" if user == nil

    #no if statement necessary here--if they make it this far their login info is valid. This puts the users idea into the session, giving it info to refer to the user by.
    session[:user_id] = user[:id]
    redirect "/login"
  end

  post "/register" do

    #we run find_user and don't let the user register if their info already exists in the database
    user = find_user
    redirect "/error" unless user == nil

    #we make a hash for the user that contains their username and password
    user = {:username => params[:username], :password => params[:password]}
    #we run the insert method to push the user info into the database, and the method adds an idea to that hash in the database. By calling [:id] we return the id number, and set that as the session info for this user.
    session[:user_id] = @user_database.insert(user)[:id]
    redirect "/login"
  end


  post "/" do
    #session delete removes our user's info from the session hash.
    session.delete(:user_id)
    redirect "/"
  end

  def find_user
    #this iterates through the @user_database array, finds the hash that has the target name and password, and returns it outside the array (that's what the [0] does). This is flawed right now because you could make a user with the same username but a different password. ALSO, I modified the user_database.rb file and removed the .dup from @user in the all method. That's the only way I could get select to work!
    @user_database.all.select { |x| x[:username] == params[:username] && x[:password] == params[:password] }[0]
  end


end
