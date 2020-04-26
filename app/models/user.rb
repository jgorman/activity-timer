# frozen_string_literal: true

class User < ApplicationRecord
  extend GuestHistory

  has_many :clients, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one :timer, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :confirmable depends on email working.
  # :omniauthable # https://github.com/advisories/GHSA-ww4x-rwq6-qpgf
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :lockable,
         :timeoutable,
         :trackable

  validates :role_s, presence: true

  def admin?
    role_s == "admin"
  end

  def user?
    role_s == "user"
  end

  def guest?
    role_s == "guest"
  end

  def has_role?(role)
    role_s == role
  end

  def display_name
    return first_name unless first_name.empty?
    return last_name unless last_name.empty?
    email.sub(/@.*/, "")
  end

  private
    before_validation {
      self[:role_s] = "user" if !persisted? && role_s.blank?
    }
end
