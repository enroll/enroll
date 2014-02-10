class BlogPost < ActiveRecord::Base
  acts_as_url :title  

  def publish!
    self.published_at = Time.now
    self.save!
  end
end
