# Homepage (Root path)
get '/' do
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
  # print the html for the player widget
  # erb embed_info['html']
  erb :'track/index'
end
