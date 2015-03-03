class UserSession < Authlogic::Session::Base
  extend ActiveModel::Naming # Needed to work with Rails 4.2 https://github.com/binarylogic/authlogic/issues/432

  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  def persisted?
    false
  end
end
