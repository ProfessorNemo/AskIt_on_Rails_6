# создаем массив в json и для каждого элемента массива
# выводим id и название тега
json.array! @tags do |tag|
  json.id tag.id
  json.title tag.title
end

# Название полей в результирующем json
# json.id
# json.title

# На выходе получится конструкция
# {
#   id: 1,
#   title: 'test'
# }
