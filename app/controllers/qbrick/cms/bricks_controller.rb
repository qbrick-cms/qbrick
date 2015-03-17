module Qbrick
  module Cms
    class BricksController < BackendController
      respond_to :html, :js
      before_action :delete_iamge_cache_params_if_params_has_image, only: :update

      def create
        create_brick_from_type_param

        if @brick.valid?
          respond_with @brick do |format|
            format.js
            format.html { redirect_to edit_cms_page_path(@brick.parents.first) }
          end
        else
          render 'new'
        end
      end

      def new
        @brick = Qbrick::Brick.new(brick_params)
      end

      def update
        @brick = Qbrick::Brick.find(params[:id])
        @brick.update_attributes(brick_params)

        respond_with @brick do |format|
          format.js
          format.html { redirect_to edit_cms_page_path(@brick.parents.first) }
        end
      end

      def destroy
        @brick = Qbrick::Brick.find(params[:id])
        @parent_brick = @brick.brick_list
        @brick.destroy
      end

      def sort
        if params[:bricks].present?
          params[:bricks][:ids].split(',').each_with_index do |id, idx|
            Qbrick::Brick.find(id).update_attribute(:position, idx.to_i + 1)
          end
        end
        render nothing: true
      end

      private

      def delete_iamge_cache_params_if_params_has_image
        params['brick'].delete('image_cache') if params['brick']['image']
      end

      def create_brick_from_type_param
        @brick = params[:brick][:type].constantize.create(brick_params)
      end

      def brick_params
        params.require(:brick).permit!
      end
    end
  end
end
