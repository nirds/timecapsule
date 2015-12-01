namespace :timecapsule do
  model_list = Dir['app/models/*.rb'].map{ |file| File.basename(file, '.*') }

  model_list.each do |klass|
    desc "Generates CSV dump of all #{klass} records"
    task klass.pluralize.to_sym => :environment do
      run_timecapsule_for(klass)
    end
  end

  def run_timecapsule_for(klass)
    Rails.application.eager_load!
    if ActiveRecord::Base.descendants.map(&:name).include? klass.classify
      Timecapsule.export_model(klass.classify.constantize)
    end
  end
end
