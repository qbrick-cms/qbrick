module Qbrick
  module Cms
    class AccountsController < BackendController
      before_filter :authenticate_admin!

      def edit
        @admin = current_admin
      end

      def update_password
        @admin = Admin.find(current_admin.id)
        if @admin.update_with_password(admin_params)
          # Sign in the admin by passing validation in case their password changed
          sign_in @admin, :bypass => true
          redirect_to cms_pages_path
        else
          render "edit"
        end
      end

      private

      def admin_params
        params.required(:admin).permit(:password, :password_confirmation, :current_password)
      end
    end
  end
end
