namespace :timecapsule do
  # Rails.application.eager_load! (breaks w/ admin/admin_controller and we're only running rake and not rails)
  # model_list = ActiveRecord::Base.connection.tables.map(&:to_sym)
  # ActiveRecord::Base.descendants.map(&:name).map(&:to_sym)
  # above didn't work because activerecord didn't load them up (they weren't being seen)
  # its not loading up the rails portion
  # dir works only if the models are xyz.rb and happily ignores other files
  model_list = Dir['app/models/*.rb'].map{ |file| File.basename(file, '.*').to_sym }
  model_list.each do |klass|
    desc "#{klass} model name - #{model_list.inspect}" # inspect the array
    task klass do
    end
  end
end
