class Resource < ActiveRecord::Base
  belongs_to :course

  validates :course_id, presence: true
  validates :name, presence: true
  validates :s3_url, presence: true
end
