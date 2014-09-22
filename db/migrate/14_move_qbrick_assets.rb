class MoveQbrickAssets < ActiveRecord::Migration
  def old_qbrick_assets_dir
    File.join(Rails.root,'public/uploads/qbrick')
  end

  def new_qbrick_assets_dir
    File.join(Rails.root,'public/uploads/cms')
  end

  def up
    if File.exists? old_qbrick_assets_dir
      puts "Moving Qbrick Assets from #{old_qbrick_assets_dir} to #{new_qbrick_assets_dir}"
      File.rename old_qbrick_assets_dir, new_qbrick_assets_dir
    end
  end

  def down
    if File.exists? new_qbrick_assets_dir
      File.rename new_qbrick_assets_dir, old_qbrick_assets_dir
    end
  end
end
