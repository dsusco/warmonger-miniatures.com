class Hash
  def stringify_keys
    self.inject({}) do |result, (key, value)|
      result[(key.is_a?(Symbol) ? key.to_s : key)] =
        (value.is_a?(Hash) ? value.stringify_keys : value)

      result
    end
  end

  def symbolize_keys
    self.inject({}) do |result, (key, value)|
      result[(key.is_a?(String) ? key.to_sym : key)] =
        (value.is_a?(Hash) ? value.symbolize_keys : value)

      result
    end
  end
end