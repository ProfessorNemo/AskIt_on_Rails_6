# frozen_string_literal: true

# Сервисный объект, который нам позволит заводить пользователей
# в системе на основе Excel
class UserBulkService < ApplicationService
  # тот архив, который вгрузили в систему
  attr_reader :archive

  # rubocop:disable Lint/MissingSuper
  def initialize(archive_param)
    # Создаем архив "@archive" на основе параметра "archive_param"
    # tempfile - метод, который позволяет получить ссылку на загруженный временный файл.
    @archive = archive_param.tempfile
  end
  # rubocop:enable Lint/MissingSuper

  def call
    Zip::File.open(@archive) do |zip_file|
      zip_file.glob('*.xlsx').each do |entry|
        # Нужно создать массив пользователей на основе файла, затем импортировать
        # сразу все и игнорировать дублирующиеся с уже сделанными валидациями
        # https://github.com/zdennis/activerecord-import
        User.import users_from(entry), validate: true, ignore: true,
                                       validate_with_context: Symbol, all_or_none: true
      end
    end
  end

  private

  # "entry" - файл excel, который нужно разобрать по ячейкам (распарсить)
  # и сделать пользователей на основе этих ячеек.
  def users_from(entry)
    # распарсить файлик ("[0]" - вытащить 1-й лист из документа)
    sheet = RubyXL::Parser.parse_buffer(entry.get_input_stream.read)[0]
    sheet.map do |row|
      # Для каждого ряда нужно вытащить его ячейки. На основе ячеей сделать юзеров.
      cells = row.cells[0..2].map { |c| c&.value.to_s }
      User.new name: cells[0],
               email: cells[1],
               password: cells[2],
               password_confirmation: cells[2]
    end
  end
end
