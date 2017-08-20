HealthCheck.setup do |config|
    config.full_checks = ['database', 'migrations', 'cache', 'redis', 'sidekiq-redis']
end
