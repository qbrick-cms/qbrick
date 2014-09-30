class RemoveCmsAdmin < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists?(:qbrick_cms_admins)
      drop_table :qbrick_cms_admins
    else
      puts 'qbrick_cms_admins table does not exist, not deleting'
    end
  end
end
