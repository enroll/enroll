class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :description
      t.string :s3_url
      t.string :transloadit_assembly_id

      t.timestamps
    end
  end
end
