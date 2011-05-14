require 'digest'
class User < ActiveRecord::Base
  
  has_many :urls
  has_many :microposts, :dependent => :destroy
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # validates :name,      :presence     => true,
  #                       :length       => { :maximum => 50 }
  
  validates :email,     :presence     => true,
                        :format       => { :with => email_regex },
                        :uniqueness   => { :case_sensitive => false }
                    
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }
                        
  before_save :encrypt_password, :generate_api_key
  #after_save :generate_api_key
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end
    
    def encrypt(passwd)
      secure_hash("#{self.salt}--#{passwd}")
    end
    
    def generate_api_key
      self.api_key = secure_hash("#{Time.now.utc}--#{self.email}")
    end
    
    def secure_hash(passwd)
      Digest::SHA2.hexdigest(passwd)
    end

end
