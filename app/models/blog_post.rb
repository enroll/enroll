class BlogPost < ActiveRecord::Base
  acts_as_url :title  
  belongs_to :author, class_name: 'User'

  def publish!
    self.published_at = Time.now
    self.save!
  end
end
