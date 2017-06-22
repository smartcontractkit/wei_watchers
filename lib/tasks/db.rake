namespace :db do
  task update: ['db:create', 'db:migrate', 'db:seed']
end
