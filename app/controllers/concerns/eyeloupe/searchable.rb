# frozen_string_literal: true

module Eyeloupe
  module Searchable
    extend ActiveSupport::Concern

    path_models = %w[InRequest OutRequest]
    name_models = %w[Job]

    included do
      before_action :set_query, only: [:index]
    end

    protected

    def set_query
      model = ("Eyeloupe::" + controller_name.classify).constantize
      where = model.attribute_names.include?("path") ? 'path' : 'classname'
      @query = params[:q].present? ? model.where("#{where} LIKE ?", "%#{params[:q].strip}%").order(created_at: :desc)
                 : model.all.order(created_at: :desc)
    end
  end

end