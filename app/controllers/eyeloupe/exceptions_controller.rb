# frozen_string_literal: true

module Eyeloupe
  class ExceptionsController < ApplicationController

    before_action :set_exception, only: %i[ show ]

    # GET /out_requests
    def index
      @pagy, @exceptions = pagy(Exception.all.order(created_at: :desc), items: 50)

      render partial: 'frame' if params[:frame].present?
    end

    # GET /out_requests/1
    def show
      start = @exception.line - 5
      start = 0 if start < 0
      @line_numbers = [*start..@exception.line+6]
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_exception
        @exception = Exception.find(params[:id])
      end

  end
end
