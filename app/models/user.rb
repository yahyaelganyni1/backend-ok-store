class User < ApplicationRecord
  has_one :cart

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist
         
         enum role: [:user, :seller, :admin]
         
         after_initialize :set_default_role, :if => :new_record?
         
         def set_default_role
          self.role ||= :user
        end
        
        
          validates :email, presence: true , on: :create
          validates :username, presence: true, on: :create
          validates :password, presence: true, length: { minimum: 6 }, on: :create
          validates :password_confirmation, presence: true, on: :create
end