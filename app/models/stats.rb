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
end    