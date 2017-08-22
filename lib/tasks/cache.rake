namespace :cache do
  desc "Clear Rails Cache"
  task clear: :environment do
    Rails.logger.warn 'Clearing Rails Cache'
    Rails.cache.clear()
  end
end
