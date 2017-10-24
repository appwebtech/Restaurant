class Recipe < ApplicationRecord
	validates :name, presence: true
	validates :description, presence: true, length: { minimum: 5, maximum: 2000 }
	belongs_to :chef
	validates :chef_id, presence: true
	default_scope -> { order(updated_at: :desc)} # View newer stuff 1st, eg recipe listing
	has_many :recipe_ingredients
	has_many :ingredients, through: :recipe_ingredients
	has_many :comments, dependent: :destroy
end