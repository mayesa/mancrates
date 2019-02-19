class ApplicationService
  attr_accessor :current_user

  def self.build(current_user)
    new(current_user)
  end

  def initialize(current_user)
    self.current_user = current_user
  end
end
