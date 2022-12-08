class SearchService
  TYPES = %w[All Question Comment Answer User].freeze

  def initialize(params)
    @request = params[:request]
    @type = params[:type]
  end

  def call
    return [] if @request.empty?

    @type == 'All' ? ThinkingSphinx.search(@request) : Object.const_get(@type).search(@request)
  end
end
