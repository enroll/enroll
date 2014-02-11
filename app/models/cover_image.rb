class CoverImage < ActiveRecord::Base
  belongs_to :course

  has_attached_file :image,
                    :styles => {
                      main: {geometry: "1688x384#"},
                      admin: {geometry: "1130x242#"},
                      background: {geometry: "2168x1626#", background: true}
                    },
                    :default_url => "/images/:style/missing.png",
                    :processors => [:thumbnail, :backgroundize]
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def as_json(options={})
    {
      admin: image.url(:admin),
      background: image.url(:background)
    }
  end
end