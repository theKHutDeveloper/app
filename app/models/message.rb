class Message < ApplicationRecord

	acts_as_messageable :table_name => "messages", # default 'messages'
         :required   => :body   # default [:topic, :body]

         belongs_to :user

end