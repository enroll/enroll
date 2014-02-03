class MarketingToken < ActiveRecord::Base
  def self.generate!(options={})
    token = MarketingToken.new(options)
    token.token = self.generate_token
    token.distinct_id = SecureRandom.base64

    token.save!

    token
  end

  protected

  def self.generate_token(length=2)
    # 20 times try to generate token that's not taken yet.
    20.times do
      token = random_string(length)
      existing = MarketingToken.where(token: token).first
      return token unless existing
    end

    # if it fails, increase length and try again.
    generate_token(length+1)
  end

  def self.random_string(length=10)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    password = ''
    length.times { password << chars[rand(chars.size)] }
    password
  end
end