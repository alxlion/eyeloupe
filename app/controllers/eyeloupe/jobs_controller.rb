module Eyeloupe
  class JobsController < ApplicationController
    include Searchable

    before_action :set_job, only: %i[ show ]

    def index
      @pagy, @jobs = pagy(@query, items: 50)

      render partial: 'frame' if params[:frame].present?
    end

    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_job
        @job = Job.find(params[:id])
      end
  end
end
