# Homepage (Root path)
get '/' do
  @tracks = Track.all
  erb :'track/index'
end
