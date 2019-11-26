class User < ApplicationRecord
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

  def is_admin?
    roles == 'admin'
  end

  def display_name
    return first_name unless first_name.empty?
    return last_name unless last_name.empty?
    email.sub(/@.*/, '')
  end
end
