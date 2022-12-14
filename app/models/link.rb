class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, :format => URI::regexp(%w(http https))

  def gist?
    url =~ /gist.github.com\/\w+\/\w+\z/
  end
end
