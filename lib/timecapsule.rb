require 'timecapsule/railtie' if defined?(Rails)
class Timecapsule
  require 'csv'

  def self.import_model(model_import, file_name = nil)
    file_name ||= Rails.root.join("#{IMPORT_DIR}#{model_import.to_s.pluralize.underscore}.csv")
    puts "Importing: #{model_import} from #{file_name}"
    csv = CSV.read(file_name)
    attributes = csv.shift
    csv.each do |row|
      hash = {}
      attributes.collect(&:to_sym).each_with_index do |key, i|
        hash[key] = row[i]
      end
      object = model_import.new(hash)
      object.save(validate: false)
    end
  end

  def self.import
    @csv_files = Dir.glob("#{IMPORT_DIR}*.csv").sort
    @csv_files.each do |file|
      model_name = build_model_name(file)
      import_model(model_name, file) if model_name.count == 0
    end
  end

  def self.export_model(model_export, order = nil, attributes = nil, import_model_name = nil)
    import_model_name ||= model_export

    check_for_and_make_directory(EXPORT_DIR)

    file_name = build_file_name(import_model_name, order)

    puts "Exporting: #{model_export} to #{file_name}"

    @file = File.open(file_name, 'w')

    column_names = attributes.sort.map { |a| a[1] } if attributes
    column_names ||= model_export.column_names.sort

    @file.puts column_names.join(',')

    model_export.all.each do |item|
      attrib = {}
      if attributes
        attributes.each do |k, _v|
          attrib[k] = item[k]
        end
      else
        attrib = fetch_attributes_for(item)
      end

      next if attrib.nil?

      @file.puts attrib.sort.collect { |_k, v| "#{delete_commas(v)}" }.join(',')
    end

    @file.close
  end

  private
    def self.check_for_and_make_directory(path)
      return true if File.exist?(path)

      path = Pathname.new(path)
      parent = path.parent

      check_for_and_make_directory(parent) unless path.parent.parent.root?

      Dir.mkdir(path) unless File.exist?(path)
    end

    def self.delete_commas(value)
      return value.delete(',') if value.is_a?(String)
      value
    end

    def self.build_model_name(file)
      file.split('/').last.split('.').first.split('-').first.classify.constantize
    end

    def self.build_file_name(import_model_name, order)
      if order.nil?
        "#{EXPORT_DIR}#{import_model_name.to_s.pluralize.underscore}.csv"
      else
        "#{EXPORT_DIR}#{import_model_name.to_s.pluralize.underscore}-#{order}.csv"
      end
    end

    def self.fetch_attributes_for(item)
      item.attributes
    rescue StandardError => e
      puts "Error! #{item.class.name} - #{item.id}: '#{e}'."
      return nil
    end
end
