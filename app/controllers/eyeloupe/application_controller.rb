module Eyeloupe
  class ApplicationController < ActionController::Base
    include Pagy::Backend

    before_action :set_config

    def root
      redirect_to in_requests_path
    end

    protected

    def set_config
      @eyeloupe_capture = cookies[:eyeloupe_capture].present? ? cookies[:eyeloupe_capture] == "true" : Eyeloupe.configuration.capture
    end
  end
end
