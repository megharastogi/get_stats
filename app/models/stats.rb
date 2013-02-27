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

  def self.show(field,time_range="week",report_start_date=nil,report_end_date=nil)
    end_date = Date.today
    case time_range 
      when 'week'   
       start_date = end_date - 1.week
      when 'month'   
       start_date = end_date - 1.month 
      else
       start_date = end_date - 1.month 
    end
    if !report_start_date.nil? && !report_end_date.nil?
      start_date = report_start_date.to_date
      end_date = report_end_date.to_date
    end
    @stats = Stats.find(:all,:conditions =>["stat_name=? and stat_date >=? and stat_date <=?",field,start_date,end_date])
    @return_stat = []
    now = start_date
    while (now <= end_date) do 
      today_stats = @stats.select{|c| c if c.stat_date == now }
      if today_stats.blank?
        @return_stat << [field,now,0]
      else
        @return_stat << [field,today_stats[0].stat_date,today_stats[0].count]  
      end
      now = now + 1.day
    end
    return @return_stat
  end 

  class << self 
    alias :daily_stats :show
  end

  def self.weekly_stats(field,report_start_date=nil,report_end_date=nil)
    if report_end_date.nil?
      report_end_date = Date.today
    end
     
    if report_start_date.nil? || report_start_date >= report_end_date
      report_start_date = report_end_date - 1.month 
    end  
    report_start_date = report_start_date - report_start_date.wday + 1
    @stats = Stats.find(:all,:conditions =>["stat_name=? and stat_date >=? and stat_date <=?",field,report_start_date,report_end_date])
    now = report_start_date
    @return_stat = []
    week_collection = 0
    while (now <= report_end_date) do
      today_stats = @stats.select{|c| c if c.stat_date == now }
      if !today_stats.blank?
        week_collection = week_collection + today_stats[0].count
      end 
      if now.monday? && now != report_start_date
        @return_stat << [field,now - 1.week ,week_collection]
        week_collection = 0
      end 

      if now == report_end_date && !now.monday?
         @return_stat << [field,now - now.wday + 1,week_collection]
      end 
      now = now + 1.day
    end  
    return @return_stat
  end
   
   def self.monthly_stats(field,report_start_date=nil,report_end_date=nil)
    if report_end_date.nil?
      report_end_date = Date.today
    end
     
    if report_start_date.nil? || report_start_date >= report_end_date
      report_start_date = report_end_date - 4.months
    end  
    report_start_date = report_start_date - report_start_date.mday + 1
    @stats = Stats.find(:all,:conditions =>["stat_name=? and stat_date >=? and stat_date <=?",field,report_start_date,report_end_date])
    now = report_start_date
    @return_stat = []
    month_collection = 0
    while (now <= report_end_date) do
      today_stats = @stats.select{|c| c if c.stat_date == now }
      if !today_stats.blank?
        month_collection = month_collection + today_stats[0].count
      end 
      if now.mday == 1 && now != report_start_date
        @return_stat << [field,now - 1.month ,month_collection]
        month_collection = 0
      end  
      if now + 1.day == report_end_date && (now + 1.day).mday != 1
         @return_stat << [field,now  ,month_collection]
      end 
      now = now + 1.day
    end  
    return @return_stat
  end
   

  def self.show_all_stat_names
    @stats = Stats.find(:all,:group => 'stat_name')
    @stat_names = []
    @stats.each{|s| @stat_names << s.stat_name}
    return @stat_names
  end  
end    