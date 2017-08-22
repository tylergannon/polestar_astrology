Rails.application.configure do
  config.x.google_api_keys = Hashie::Mash.new({
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET']
  })
end
