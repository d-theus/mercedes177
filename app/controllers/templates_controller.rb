class TemplatesController < ApplicationController
  def show
    render template: "#{params[:ctrl]}/#{params[:name]}", layout: false
  end
end
