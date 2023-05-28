# frozen_string_literal: true

module Eyeloupe
  class ConfigsController < ApplicationController

    before_action :set_config, only: [:update]

    def update
      Eyeloupe.configuration.capture = @value == "true"
      cookies[:eyeloupe_capture] = @value
      redirect_to root_path, status: 303
    end

    protected

    def set_config
      @value = params[:value]
    end
  end
end