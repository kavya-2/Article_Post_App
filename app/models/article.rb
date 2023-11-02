class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true 
  validates :content, presence: true, length: {minimum: 10} 
  enum visibility: { draft: 'draft', public: 'public' }, _prefix: true
  # enum visibility: { draft: 'draft', public: 'public' }
end
