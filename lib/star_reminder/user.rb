# frozen_string_literal: true
class User < Model
  attribute :email
  unique :email
  index :email

  counter :digest_count

  set :sent, :GithubStar
  collection :following, :GithubUser

  DIGEST_COUNT = 2

  def after_create
    increment :digest_count, DIGEST_COUNT
  end

  # TODO: unfollow
  def follow(github_user)
    return if followed? github_user
    github_user.user = self
    github_user.save
  end

  def followed?(github_user)
    following.include? github_user
  end

  def send_digest
    if digest.count.zero?
      puts "No digest to send"
      return
    end

    Mailer.welcome(to: email, payload: digest).deliver_now
  end

  def digest
    stars = generate_digest
    return stars if stars.count >= DIGEST_COUNT

    stars = generate_digest(refresh: true)
    return stars if stars.count >= DIGEST_COUNT

    []
  end

  def generate_digest(refresh: false)
    fetch_stars if refresh

    following.reduce([]) do |ret, source_user|
      ret + source_user.stars.select { |st| !sent.include?(st) }.sample(DIGEST_COUNT)
    end
  end

  def fetch_stars
    following.each(&:fetch_stars)
  end
end
