require 'museum_data'
require 'rktl_data'
task :convert_museum_data, :museum_filename do |t, args|
	museum_parser = MuseumData::Parser.new
	museum_parser.parse(args[:museum_filename])
	museum_parser.print_errors
end

task :convert_rktl_data, :pairs_filename, :places_filename, :counts_2011_filename, :counts_2012_filename do |t, args|
	rktl_parser = RktlData::Parser.new
	rktl_parser.parse(args[:pairs_filename], args[:places_filename], args[:counts_2011_filename], args[:counts_2012_filename])
	rktl_parser.print_errors
end
