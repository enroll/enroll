class Resource < ActiveRecord::Base
  belongs_to :course

  validates :course_id, presence: true
  validates :name, presence: true
  validates :s3_url, presence: true, if: :file?
  validates :link, presence: true, if: :link?

  def file?
    resource_type == 'file'
  end

  def link?
    resource_type == 'link'
  end
end
