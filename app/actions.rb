get '/logout' do
  session.clear
  redirect '/'
end

get '/' do
  @user = User.find(session[:user_id]) if session[:user_id]
  if session[:message]
    @message = session[:message]
    @message_type = session[:status]
    session.delete(:message)
    session.delete(:status)
  end

  @tracks = Track.all
  @tracks_embed = {}
  @tracks.each do |track|
    if !track.url.nil?
      # create a client object with your app credentials
      client = Soundcloud.new(:client_id => settings.soundcloud_id)
      # get a tracks oembed data
      track_url = track.url
      embed_info = client.get('/oembed', :url => track_url)
      @tracks_embed[track.id] = embed_info['html']
    end
  end
  erb :'track/index'
end

post '/user/new' do
  @user = User.new(
    email: params[:email],
    password: params[:password]
    )
  if @user.save
    session[:message] = 'User account created!'
    session[:status] = 1
  else
    session[:message] = 'The account is exist, please choose another email or login.'
    session[:status] = 0
  end
  redirect '/'
end

post '/track/new' do
  # create a client object with your app credentials
  client = Soundcloud.new(:client_id => settings.soundcloud_id)
  # get a tracks oembed data
  # binding.pry
  track_url = params[:url]
  embed_info = client.get('/oembed', :url => track_url)
  # create new track
  @track = Track.new(
    title: embed_info[:title],
    author: embed_info[:author_name],
    url: track_url
  )
  if @track.save
    redirect '/'
  else
    erb :'track/index'
  end
end

post '/login' do
  user = User.where(email: params[:email], password: params[:password]).first
  if user
    session[:user_id] = user.id
    session[:message] = 'Welcome Back ' << user.email << '!'
    session[:status] = 1
  else
    session[:message] = 'Wrong email or password, please try again.'
    session[:status] = 0
  end
  redirect '/'
end
