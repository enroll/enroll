class CoverImage < ActiveRecord::Base
  belongs_to :course

  has_attached_file :image,
                    :styles => { :main => "844x192#" },
                    :default_url => "/images/:style/missing.png",
                    :processor => [:background]
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end