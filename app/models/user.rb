# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  # виртуальный аттрибут в БД попадать не будет, чтоб существовал
  # на объекте user метод old_password
  attr_accessor :old_password, :remember_token

  has_secure_password validations: false

  validate :password_presence
  # Эту валидацию запускать только при обновлении записи и если указан новый пароль
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }

  #  без обращения к DNS-почтовым серверам для проверки существования доменного
  # проверяем корректность вводимых емэйлов
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validate :password_complexity

  # before_save - функция обратного вызова, которая выполняется каждый раз перед тем,
  # как запись сохраняется в БД, когда email изменился с прошлого сохранения
  before_save :set_gravatar_hash, if: :email_changed?

  # rubocop:disable Rails/SkipsModelValidations
  # сгенерировать token (абракадабра), на основе которого будем делать хэш
  def remember_me
    # self - чтобы пристыковать виртуальный аттрибут "remember_token" к текущему юзеру
    self.remember_token = SecureRandom.urlsafe_base64
    # поместить token в табличку c помощью update_column
    update_column :remember_token_digest, digest(remember_token)
  end

  # Когда юзер выходит из системы, нам нужно всю информацию о нем очистить
  def forget_me
    update_column :remember_token_digest, nil

    # не обязательно, в целях полноты
    self.remember_token = nil
  end
  # rubocop:enable Rails/SkipsModelValidations

  # Проверить, что тот token, который нам передается и тот, которы в БД - одно и то же
  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank?

    # Хэш "remember_token_digest" такой же, который получается из строки "remember_token"
    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
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

  def correct_old_password
    # Если дайджесты совпали
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password,
               'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase,' \
               '1 lowercase,1 digit and 1 special character'
  end

  def password_presence
    # Добавить для пароля сообщение, что от пустой
    errors.add(:password, :blank) if password_digest.blank?
  end
end
