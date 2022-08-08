# frozen_string_literal: true

class User < ApplicationRecord
  include Blacklist
  include Recoverable
  include Rememberable

  # ролей может быть сколько угодно, наприер 3 - superadmin....
  # Например: "u.admin_role?" - здесь role - suffix
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role

  # Например: "u.activated_status?" - здесь role - suffix
  enum status: { activated: 0, blocked: 1 }, _suffix: :status

  # роль должна быть
  validates :role, presence: true

  # статус должен быть
  validates :status, presence: true

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  # виртуальный аттрибут в БД попадать не будет, чтоб существовал
  # на объекте user метод old_password
  attr_accessor :old_password, :remember_token, :admin_edit

  has_secure_password validations: false

  validate :password_presence

  # Эту валидацию нужно запускать только при обновлении записи и только  в том случае,
  # если новый пароль был указан. Если нет - значит юзер пароль менять не хочет, - игнорируем.
  # Если юзера меняет админ, тогда эту валидацию делать не нужно
  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }

  #  без обращения к DNS-почтовым серверам для проверки существования доменного
  # проверяем корректность вводимых емэйлов
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  validate :password_complexity

  validate :necessary_email

  validate :necessary_name

  # before_save - функция обратного вызова, которая выполняется каждый раз перед тем,
  # как запись сохраняется в БД, когда email изменился с прошлого сохранения
  before_save :set_gravatar_hash, if: :email_changed?

  # не гость
  def guest?
    false
  end

  # Юзер м.б. автором вопроса, ответа, комментария, поэтому "obj".
  # И скажем obj.user == self (т.е.  obj.user - это сам юзер).
  # У вопросов, ответов и комм-ев есть метод "user"
  def author?(obj)
    obj.user == self
  end

  private

  # функция обратного вызова
  def set_gravatar_hash
    return if email.blank?

    # Генерируем хэш на основе email-юзера, удаляем пробелы сначала и конца и преобразуем
    # его к нижнему регистру - это требования граватара. Потом на основе этого делаем хэш.
    hash = Digest::MD5.hexdigest email.strip.downcase

    # присвоить сохраняемой в данный момент записи (для которой выполнен callback) gravatar_hash
    # и установить его в значение hash. Перед тем, как юзера сохранить (user.save), к нему
    # пристыкуется еще значение "self.gravatar_hash = hash"
    self.gravatar_hash = hash
  end

  # сгенерировать хэш на основе строки
  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # "password_digest_was" - метод (создает RoR автоматически), который говорит, что нужно
  # вытащить старый digest, который в БД, а не новый, который хранится в памяти. Сделаем digest
  # на основе старого пароля (old_password) и сравним с тем, какой  в БД (password_digest_was).
  # Если дайджесты совпали, значит старый пароль введен верно.
  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add(:old_password, :correct_error)
  end

  # проверка для сложности пароля
  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add(:password, :correct_error)
  end

  # Нужно добавить для пароля сообщение, что он пустой, но не в том случае, если
  # "password_digest" был уже указан. Если пароль был задал раньше, то в этом случае
  # пароль можно указывать, а можно не указывать
  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end

  # проверка подходящего email для регистрации
  def necessary_email
    blacklist
    errors.add(:email, :registration_error) if blacklist.any?(email.split('@')[0])
  end

  # проверка подходящего имени для регистрации
  def necessary_name
    blacklist
    errors.add(:name, :registration_error) if blacklist.any?(name.downcase)
  end
end
