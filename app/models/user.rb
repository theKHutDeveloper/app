class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_messageable :table_name => "messages", # default 'messages'
         :required   => :body                  # default [:topic, :body]
        

  belongs_to :locker

  #scope :assigned, -> Locker.where{ (locker_id: = User.locker_id) }
end
