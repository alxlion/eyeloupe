# frozen_string_literal: true

module Eyeloupe

  class DataController < ApplicationController

    # Delete all data in the database
    # DELETE /data
    def destroy
      Exception.destroy_all
      InRequest.destroy_all
      OutRequest.destroy_all
      redirect_to root_path, status: 303
    end
  end

end