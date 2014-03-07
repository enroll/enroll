class CoverImage < ActiveRecord::Base
  ADMIN_HEIGHT = 242
  MAIN_HEIGHT = 384

  belongs_to :course

  has_attached_file :image,
                    styles: {
                      main: {geometry: "1688x9999>"},
                      admin: {geometry: "1130x9999>"},
                      background: {geometry: "2168x1626#", background: true}
                    },
                    default_url: "/images/:style/missing.png",
                    processors: [:thumbnail, :backgroundize],
                    # These are here, because calling Enroll.s3_config
                    # doesn't work from application.rb.
                    storage: 's3',
                    s3_credentials: {
                      bucket: Enroll.s3_config["bucket"]["cover_images"],
                      access_key_id: Enroll.s3_config["access_key_id"],
                      secret_access_key: Enroll.s3_config["secret_access_key"]
                    },
                    url: ':s3_domain_url',
                    path: "/:class/:id_:basename.:style.:extension"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def as_json(options={})
    {
      id: id,
      admin: image.url(:admin),
      background: image.url(:background)
    }
  end

  def offset_admin_px=(value)
    self.offset = value.to_f / ADMIN_HEIGHT.to_f
  end

  def offset_admin_px
    return 0 unless self.offset
    (self.offset * ADMIN_HEIGHT).to_i
  end

  def offset_main_px
    return 0 unless self.offset
    (self.offset * MAIN_HEIGHT).to_i
  end

  def offset_main_percent
    return 0 unless self.offset
    # raise self.offset.inspect
    (self.offset * 100).to_i
  end
end