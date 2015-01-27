get '/logout' do
  session.clear
  redirect '/'
end

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
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

post '/login' do
  user = User.where(email: params[:email], password: params[:password]).first
  if user
    session[:user_id] = user.id
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
