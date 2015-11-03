require 'active_record'
require 'active_support'
require 'rails'

module Rails
  def self.root
    Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end
end

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class Timecapsule
  default_config = { import_directory: 'db/seed_data/',
                     export_directory: 'db/seed_data/' }
  IMPORT_DIR ||= default_config[:import_directory]
  EXPORT_DIR ||= default_config[:export_directory]
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.string :username
    t.string :password
  end

  create_table :posts do |t|
    t.string :title
    t.string :body
    t.integer :user_id
  end

  create_table :names do |t|
    t.string :name
    t.string :other_name
  end
end

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Name < ActiveRecord::Base
end
