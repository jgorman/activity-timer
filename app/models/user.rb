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

  validates :roles, presence: true

  def admin?
    roles == 'admin'
  end

  def user?
    roles == 'user'
  end

  def guest?
    roles == 'guest'
  end

  def has_role?(role)
    roles == role
  end

  def display_name
    return first_name unless first_name.empty?
    return last_name unless last_name.empty?
    email.sub(/@.*/, '')
  end

  private

  before_validation {
    write_attribute(:roles, 'user') if !persisted? && roles.blank?
  }
end
