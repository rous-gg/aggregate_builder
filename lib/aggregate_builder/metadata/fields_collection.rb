class FieldsCollection < Array
  def find(field_name)
    detect do |field|
      field.field_name == field_name
    end
  end
end
