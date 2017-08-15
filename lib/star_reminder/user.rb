# frozen_string_literal: true
class User < Model
  attribute :email
  unique :email
  index :email

  attribute :digest_count, Type::Integer
  attribute :digest_hour, Type::Integer
  attribute :digest_frequency
  attribute :digest_meridiem

  set :sent, :GithubStar
  collection :following, :GithubUser

  DEFAULT_SETTING = {
    digest_count: 2,
    digest_frequency: "every week",
    digest_hour: 8,
    digest_meridiem: "am"
  }

  def after_create
    update(DEFAULT_SETTING)

    statsd.increment("user", sample_rate: 1)
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
    stars = digest
    if stars.count.zero?
      logger.info "No digest to send to #{self}"
      return
    end

    Mailer.welcome(to: email, payload: stars).deliver_now
    statsd.increment("user.sent", sample_rate: 1)
  rescue => e
    logger.error "Failed sending email to #{self}"
    raise e
  else
    logger.info "Successfully sent email to #{self}"
    flag_sent(stars)
  end

  def digest
    stars = generate_digest
    return stars if stars.count >= digest_count

    stars = generate_digest(refresh: true)
    return stars if stars.count >= digest_count

    []
  end

  def generate_digest(refresh: false)
    fetch_stars if refresh

    following.reduce([]) do |ret, source_user|
      ret + source_user.stars.select { |st| !sent.include?(st) }.sample(digest_count)
    end
  end

  def fetch_stars
    following.each(&:fetch_stars)
  end

  def to_s
    "#{self.class.name}<#{email}>"
  end

  private

  def flag_sent(stars)
    redis.call "sadd", key[:sent], *stars.map(&:id)
  end
end
