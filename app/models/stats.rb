class Stats < ActiveRecord::Base
  attr_accessible :stat_name
  attr_accessible :stat_date
  attr_accessible :count
  
  def self.increment(field,date= Time.now)
      stat = Stats.find(:first,:conditions =>["stat_name=? and stat_date =?",field,date.to_date])
      if stat
          stat.update_attributes(:count => stat.count + 1)
      else
          stat = Stats.create!(:stat_name => field,:stat_date => date.to_date,:count => 1)
      end   
  end

  def self.process_daily_stats(field, stats, start_date,end_date)
    @return_stat = []
    while (start_date <= end_date) do 
      today_stats = @stats.select{|c| c if c.stat_date == start_date }
      if today_stats.blank?
        @return_stat << [field,start_date,0]
      else
        @return_stat << [field,today_stats[0].stat_date,today_stats[0].count]
      end
      start_date = start_date + 1
    end
    return @return_stat
  end  

  def self.find_date_range(time_range)
    end_date = Date.today
    case time_range 
      when 'week'   
       start_date = end_date - 1.week
      when 'month'   
       start_date = end_date - 1.month 
      else
       start_date = end_date - 1.week 
    end
    return start_date, end_date
  end  

 def self.show(field,time_range="week",report_start_date=nil,report_end_date=nil)
    start_date,end_date = find_date_range(time_range)
    if !report_start_date.nil? && !report_end_date.nil?
      start_date = report_start_date.to_date
      end_date = report_end_date.to_date
    end
    @stats = Stats.find(:all,:conditions =>["stat_name=? and stat_date >=? and stat_date <=?",field,start_date,end_date])
    process_daily_stats(field, @stats,start_date,end_date)
  end 

  class << self 
    alias :daily_stats :show
  end

  ["monthly","weekly"].each do |name|
  class_eval %{ def self.#{name}_stats(field,report_start_date=nil,report_end_date=nil)
                  start_date,end_date = process_dates("#{name}",report_start_date,report_end_date)
                  process_weekly_and_monthly_stats("#{name}",field,start_date,end_date)
                end
              }
  end
 

  def self.process_weekly_and_monthly_stats(method_type,field,start_date,end_date)
    @stats = Stats.find(:all,:conditions =>["stat_name=? and stat_date >=? and stat_date <=?",field,start_date,end_date])
    @return_stat = []
    stat_collection = 0
    original_start_date = start_date
    while (start_date <= end_date) do 
      today_stats = @stats.select{|c| c if c.stat_date == start_date }
      stat_collection = stat_collection + today_stats[0].count if !today_stats.blank?
      conitions_day = (method_type == "weekly" ? start_date.monday? : (start_date.mday == 1) )
      if conitions_day && start_date != original_start_date
        @return_stat << [field,(method_type == "weekly" ? start_date - 1.week : start_date - 1.month ),stat_collection]
        stat_collection = 0
      end 
      if start_date + 1.day == end_date && !conitions_day
           @return_stat << [field,start_date,stat_collection]
      end 
      start_date = start_date + 1.day
    end  
    return @return_stat
  end 

  def self.process_dates(method_type,start_date,end_date)
    end_date = Date.today if end_date.nil?
    if start_date.nil? || start_date >= end_date
      start_date = end_date - 4.months if method_type == "monthly"
      start_date = end_date - 1.month if method_type == "weekly"
    end  
    if method_type == "weekly"
      start_date = start_date - start_date.wday + 1
    else
      start_date = start_date - start_date.mday + 1
    end  
    return start_date, end_date
  end 

  def self.show_all_stat_names
    @stats = Stats.find(:all,:group => 'stat_name')
    @stat_names = []
    @stats.each{|s| @stat_names << s.stat_name}
    return @stat_names
  end  
end    