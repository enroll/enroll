class BlogPost < ActiveRecord::Base
  acts_as_url :title  
  belongs_to :author, class_name: 'User'

  def publish!
    self.save!
  end
end
