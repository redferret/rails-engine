class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginate(page, per_page)
    from = (page - 1) * per_page
    all.limit(per_page).offset(from)
  end
end
