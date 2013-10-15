class FieldsCollection
  def initialize
    @fields = {}
    @size = 0
  end

  def find(field_name)
    @fields[field_name.to_sym]
  end

  def <<(field)
    field.keys.each do |key|
      @fields[key] = field
    end
    @size += 1
    self
  end

  def delete(field_name)
    field = find(field_name)
    field.keys.each do |key|
      @fields.delete(key)
    end
    @size -= 1
    self
  end

  def size
    @size
  end

  def clone
    clonned_fields = self.class.new
    @fields.each do |field_key, field|
      clonned_fields << field.dup
    end
    clonned_fields
  end
end
