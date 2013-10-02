class FieldsCollection < Array
  def find(field_name)
    detect do |field|
      field.field_name == field_name
    end
  end

  def clone
    clonned = self.class.new
    each do |v|
      clonned << v.dup
    end
    clonned
  end
end
