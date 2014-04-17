class AddAttachmentInstructorPhotoToCourse < ActiveRecord::Migration
  def self.up
    change_table :courses do |t|
      t.attachment :instructor_photo
    end
  end

  def self.down
    drop_attached_file :courses, :instructor_photo
  end
end
