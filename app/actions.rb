get '/logout' do
  session.clear
  redirect '/'
end

get '/' do
  @user = User.find(session[:user_id]) if session[:user_id]
  if session[:message]
    @message = session[:message]
    case session[:status]
      when 0
        @message_type = 'alert'
      when 1
        @message_type = 'success'
    end
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
  track_url = params[:url]
  begin
    embed_info = client.get('/oembed', :url => track_url)
  rescue SoundCloud::ResponseError => e
    session[:message] = 'No track found based on your SoundCloud url.'
    session[:status] = 0
    redirect '/'
  end
  # create new track
  @track = Track.new(
    title: embed_info[:title],
    author: embed_info[:author_name],
    url: track_url,
    user_id: session[:user_id]
  )
  if @track.save
    session[:message] = 'New track "' << embed_info[:title] << '" created.'
    session[:status] = 1
    redirect '/'
  else
    session[:message] = 'Failed to add new track, please double check the Soundcloud url.'
    session[:status] = 0
    erb :'track/index'
  end
end

post '/login' do
  user = User.where(email: params[:email], password: params[:password]).first
  if user
    session[:user_id] = user.id
    session[:message] = 'Welcome Back ' << user.email << '!'
  else
    session[:message] = 'Wrong email or password, please try again.'
    session[:status] = 0
  end
  redirect '/'
end

post '/vote/:id' do
  track = Track.find(params[:id])
  track[:votes] += 1
  track.save
  redirect '/'
end
