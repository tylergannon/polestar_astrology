namespace :db do
  desc "Reload Database"
  task :reload do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:rollback"].invoke
    Rake::Task["db:rollback"].reenable
    Rake::Task["db:rollback"].invoke
    `pg_restore -Fc -a -d polestar_development polestar.bak`
    Rake::Task["db:migrate"].reenable
    Rake::Task["db:migrate"].invoke
  end
end
