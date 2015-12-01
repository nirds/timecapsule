namespace :timecapsule do
  model_list = Dir['app/models/*.rb'].map{ |file| File.basename(file, '.*').to_sym }

  model_list.each do |klass|
    desc "#{klass} model name"
    task klass => :environment do
      run_timecapsule_for(klass)
    end
  end

  def run_timecapsule_for(klass)
    Rails.application.eager_load!
    if ActiveRecord::Base.descendants.map(&:name).include? klass.to_s.classify
      Timecapsule.export_model(klass.to_s.classify.constantize)
    end
  end
end
