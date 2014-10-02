module Qbrick
  class Setting < ActiveRecord::Base
    
    serialize :value
    
    def self.method_missing(method, *args)
          
      method = method.to_s
      
      # set
      if method[-1,1] == "="
        
        if args.size > 0
          method = method.chop
          value = {:value => args[0]}
          setting = self.where(key: method).first
          if value[:value].nil?
            setting.destroy if setting
          else
            setting = self.new if !setting
            setting.key = method.to_s
            setting.value = value[:value]
            if setting.save
              return value[:value]
            end
          end
        end
        
      # get
      else 
        return self.where(key: method).first.value
      end
      return nil
    end
  end
end
