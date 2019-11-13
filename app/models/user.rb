class User < ApplicationRecord
  has_many :clients, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :confirmable depends on email working.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable, :omniauthable

  def is_admin?
    roles == 'admin'
  end

  def display_name
    first_name.empty? ? email.sub(/@.*/, '') : first_name
  end

end
