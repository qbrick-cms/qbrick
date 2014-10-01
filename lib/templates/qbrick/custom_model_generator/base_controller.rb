module Qbrick
  class BaseController < Qbrick::Cms::AdminController
    inherit_resources

    def show
      super do |format|
        format.html { redirect_to collection_path }
      end
    end

    private

    def permitted_params
      params.permit(resource_instance_name => collection.editable_attributes)
    end
  end
end
