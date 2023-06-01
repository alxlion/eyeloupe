# frozen_string_literal: true

module Eyeloupe
  class OutRequestsController < ApplicationController
    include Searchable

    before_action :set_out_request, only: %i[ show ]

    # GET /out_requests
    def index
      @pagy, @requests = pagy(@query, items: 50)

      render partial: 'frame' if params[:frame].present?
    end

    # GET /out_requests/1
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_out_request
        @request = OutRequest.find(params[:id])
      end

  end
end
