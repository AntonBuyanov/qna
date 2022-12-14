class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :find_link

  def destroy
    @link.destroy
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
