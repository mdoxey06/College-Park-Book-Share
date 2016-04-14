class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :phone_num, :listing_id
	listing_ids = Array.new

	validates :password, :name, :email, :phone_num => true
	validates :password, :length => {:in => 8..20}
	validates :password, :format => { :with => /.*[A-Z].*/ }
	validates :password, :format => { :with => /.*[0-9].*/ }
	validates :email, :uniqueness => { :case_sensitive => false }
	validates :email, :format => { :with => /@/, :message => " is invalid" }
	validates :email, :format => { :with => /umd/, :message => " must be a UMD email" }
	validates :phone_num, :format => { :with => /[0-9]{3}-[0-9]{3}-[0-9]{4}/, :message => "Enter phone number in XXX-XXX-XXXX format" }

  def password
    p_hash ? @password ||= BCrypt::Password.new(p_hash) : nil
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.p_hash = @password
  end

  def add_listing(email, listing)
    @student = Student.find_by_email(email)
    @listing = Listing.find_by_email(email)
    if @student.email == @listing.user_email
      @listing_ids << @listing.id
    else
      nil
    end
  end

  def self.authenticate(email, test_password)
  	student = Student.find_by_email(email)
  	if student && student.password == test_password
   	 student
	else
      nil
	end
  end



end
