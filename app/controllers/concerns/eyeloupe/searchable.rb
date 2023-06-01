# frozen_string_literal: true

module Eyeloupe
  module Searchable
    extend ActiveSupport::Concern

    included do
      before_action :set_query, only: [:index]
    end

    protected

    def set_query
      model = ("Eyeloupe::" + controller_name.classify).constantize
      @query = params[:q].present? ? model.where('path LIKE ?', "%#{params[:q].strip}%").order(created_at: :desc)
                 : model.all.order(created_at: :desc)
    end
  end

end