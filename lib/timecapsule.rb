require 'timecapsule/railtie' if defined?(Rails)
class Timecapsule

  require 'csv'

  def self.import_model(model_import, file_name=nil)
    file_name ||= Rails.root.join("#{IMPORT_DIR}$#{model_import.to_s.pluralize.underscore}.csv")
    puts "Importing: #{model_import} from #{file_name}"
    csv = CSV.read(file_name)
    attributes = csv.shift
    csv.each do |row|
      hash = {}
      attributes.collect{|k| k.to_sym}.each_with_index do |key,i|
        hash[key] = row[i]
      end
      object = model_import.new(hash)
      object.save(:validate => false)
    end
  end

  def self.import
    @csv_files = Dir.glob("#{IMPORT_DIR}*.csv").sort
    @csv_files.each do |file|
      if file.include?('$')
        model_name = file.split('$').last.split('.').first.classify.constantize
      else
        model_name = file.split('/').last.split('.').first.classify.constantize
      end
      if model_name.count == 0
        Timecapsule.import_model(model_name, file)
      end
    end
  end

  def self.export_model(model_export, order=nil, attributes=nil, import_model_name=nil)
    import_model_name ||= model_export

    Timecapsule.check_for_and_make_directory(EXPORT_DIR)

    puts "Exporting: #{model_export} to #{EXPORT_DIR}#{order.to_s}$#{import_model_name.to_s.pluralize.underscore}.csv"

    @file = File.open("#{EXPORT_DIR}#{order.to_s}$#{import_model_name.to_s.pluralize.underscore}.csv", "w")

    column_names = attributes.sort.map{|a| a[1]} if attributes
    column_names ||= model_export.column_names.sort

    @file.puts column_names.join(",")

    model_export.all.each do |item|
      attrib = {}
      if attributes
        attributes.each do |k,v|
          attrib[k] = item[k]
        end
      else
        attrib = item.attributes
      end

      @file.puts attrib.sort.collect{|k,v| "#{Timecapsule.output(v)}"}.join(",")
    end

    @file.close
  end

  def self.output(value)
    if value.is_a?(String)
      return value.gsub(",",'')
    end
    value
  end
end
