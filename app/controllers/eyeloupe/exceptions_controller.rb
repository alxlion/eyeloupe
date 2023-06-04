# frozen_string_literal: true

module Eyeloupe
  class ExceptionsController < ApplicationController

    before_action :set_exception, only: %i[ show ]

    # GET /out_requests
    def index
      @pagy, @exceptions = pagy(Exception.all, items: 50)

      render partial: 'frame' if params[:frame].present?
    end

    # GET /out_requests/1
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_exception
        @exception = Exception.find(params[:id])
      end

  end
end
