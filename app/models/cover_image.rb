class CoverImage < ActiveRecord::Base
  belongs_to :course

  has_attached_file :image,
                    styles: {
                      main: {geometry: "1688x384#"},
                      admin: {geometry: "1130x242#"},
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
      admin: image.url(:admin),
      background: image.url(:background)
    }
  end
end