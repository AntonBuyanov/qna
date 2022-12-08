class SearchController < ApplicationController
  skip_authorization_check

  def search
    @result = SearchService.new(request_params).call
  end

  private

  def request_params
    params.permit(:request, :type)
  end
end
