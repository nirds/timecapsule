require 'spec_helper'
require 'database_cleaner'

describe Timecapsule do
    after(:each) do
    system "rm -rf #{Pathname.new(Timecapsule::EXPORT_DIR).parent}"
    system "rm -rf #{Timecapsule::EXPORT_DIR}"
    system "rm -rf #{Rails.root.join('config')}"
  end
  
  it 'should export a model' do
    Timecapsule.export_model(User)
    expect(File.exist?("#{Timecapsule::EXPORT_DIR}users.csv")).to be true
  end
  
  it 'should export_model part of a model' do
    User.create!(first_name: 'test', last_name: 'tester')
    Timecapsule.export_model(User, nil,
                            { first_name: :name, last_name: :other_name },
                            'name')
  
    expect(File.exist?("#{Timecapsule::EXPORT_DIR}names.csv")).to be true
  end
  
  it 'should import a model' do
    expect{Timecapsule.import_model(User, 'spec/users.csv')}.to change{User.count}.by(1)
    expect(User.last.first_name).to eq 'test'
  end
  
  it 'should import all the models' do
    old_import_dir = Timecapsule::IMPORT_DIR
    silently_do{ Timecapsule::IMPORT_DIR = "spec/" }
    
    expect{Timecapsule.import}.to change{Post.count}.by(1).and change{User.count}.by(1)
    expect(Post.last.title).to eq 'Test Post'
    
    silently_do{ Timecapsule::IMPORT_DIR = old_import_dir }
  end
end
