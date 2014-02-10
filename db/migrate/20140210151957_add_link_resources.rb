class AddLinkResources < ActiveRecord::Migration
  def change
    add_column :resources, :resource_type, :string
    add_column :resources, :link, :string
  end
end
