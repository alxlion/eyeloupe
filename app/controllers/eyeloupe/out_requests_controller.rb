# frozen_string_literal: true

module Eyeloupe
  class OutRequestsController < ApplicationController
    before_action :set_out_request, only: %i[ show ]

    # GET /out_requests
    def index
      @pagy, @requests = pagy(OutRequest.all.order(created_at: :desc), items: 50)
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
