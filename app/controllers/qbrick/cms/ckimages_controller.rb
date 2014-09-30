module Qbrick
  module Cms
    class CkimagesController < AdminController
      layout 'qbrick/cms/ckimages'
      skip_before_action :verify_authenticity_token
      respond_to :html, :js

      def create
        @func_num = params['CKEditorFuncNum']
        @ck_editor = params['CKEditor']
        @ckimage = Qbrick::Ckimage.create(file: params[:upload])
      end

      def index
        @func_num = params['CKEditorFuncNum']
        @ck_editor = params['CKEditor']
        @ckimages = Qbrick::Ckimage.all
      end

      def destroy
        @ckimage = Qbrick::Ckimage.find(params[:id])
        @ckimage.destroy
      end
    end
  end
end
