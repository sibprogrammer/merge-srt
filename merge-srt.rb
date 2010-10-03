#!/usr/bin/env ruby

def load_subtitles(filename, as_hash = false)
  subtitles = as_hash ? {} : []
  File.open(filename) do |file|
    while !file.eof? do
      record = []
      while (line = file.gets).strip != '' and !file.eof? do
        record << line
      end
      next if 0 == record.size
      timeframe = record[1].chomp
      if as_hash
        subtitles[timeframe.split[0]] = { :index => record[0], :timeframe => timeframe, :text => record[2,record.size-1] }
      else
        subtitles << { :index => record[0], :timeframe => timeframe, :text => record[2,record.size-1] }
      end
    end
  end

  subtitles
end

def merge_subtitles(main_subtitles, addon_subtitles)
  main_subtitles.each do |record|
    start_time = record[:timeframe].chomp.split[0]
    if addon_subtitles.has_key?(start_time)
      record[:text] << addon_subtitles[start_time][:text]
    end
  end
end

def print_subtitles(subtitles)
  subtitles.each do |record|
    puts record[:index]
    puts record[:timeframe]
    puts record[:text]
    puts
  end
end

if ARGV.length != 2
  puts "Usage: #{$0} main.srt addon.srt"
  exit 0
end

main_filename = ARGV.shift
addon_filename = ARGV.shift

main_subtitles = load_subtitles(main_filename)
addon_subtitles = load_subtitles(addon_filename, :as_hash => true)
merged_subtitles = merge_subtitles(main_subtitles, addon_subtitles)
print_subtitles(merged_subtitles)

