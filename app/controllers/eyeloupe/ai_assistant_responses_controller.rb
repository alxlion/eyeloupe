# frozen_string_literal: true

module Eyeloupe
  class AiAssistantResponsesController < ApplicationController

    before_action :set_exception, only: %i[ show ]

    def show
      client = OpenAI::Client.new

      code = File.read(@exception.file)

      @response = client.chat(
        parameters: {
          model: Eyeloupe::configuration.openai_model,
          messages: [{"role": "system", "content": "You are a Ruby on Rails software developer, you develop software programs and applications using programming languages like Ruby and Ruby on Rails and development tools."},
                     {"role": "user", "content": "I have a problem with my Ruby on Rails application. I am getting an error message that says:  #{@exception.kind} #{@exception.message}. Here is my code, the error is in line #{@exception.line}: #{code}. Answer as concise as possible. Show me resulting code. The response should in Markdown format."}],
          temperature: 0.7
        })

      render json: @response
    end

    private

    def set_exception
      @exception = Exception.find(params[:id])
    end
  end
end