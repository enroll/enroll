class BlogPost < ActiveRecord::Base
  acts_as_url :title  
end
