class AddAttachmentImageToCoverImages < ActiveRecord::Migration
  def self.up
    change_table :cover_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :cover_images, :image
  end
end
