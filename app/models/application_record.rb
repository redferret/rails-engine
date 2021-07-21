class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginate(page, per_page, records = all)
    from = (page - 1) * per_page
    records.limit(per_page).offset(from)
  end
end
