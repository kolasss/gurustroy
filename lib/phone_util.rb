class PhoneUtil

  # убрать все символы, кроме цифр
  def PhoneUtil.format phone
    phone.gsub(/[^0-9]/i, '') if phone
  end
end
