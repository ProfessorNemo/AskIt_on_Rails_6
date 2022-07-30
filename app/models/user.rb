class User < ApplicationRecord
  # виртуальный аттрибут в БД попадать не будет, чтоб существовал
  # на объекте user метод old_password
  attr_accessor :old_password

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

  private

  def correct_old_password
    # Если дайджесты совпали
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password,
               'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase,'\
                '1 lowercase,1 digit and 1 special character'
  end

  def password_presence
    # Добавить для пароля сообщение, что от пустой
    errors.add(:password, :blank) if password_digest.blank?
  end
end
