class Hash
  def deep_reference(key)
    self.reduce(self[key]) { |value, (k, v)|
      v.is_a?(Hash) ? ((value + v.deep_reference(key)) rescue v.deep_reference(key)) : value
    }
  end

  def dig_assignment(*keys, value)
    last_key = keys.pop
    hash = keys.reduce(self) { |hash, key| hash[key].nil? ? hash[key] = {} : hash[key] }

    hash.has_key?(last_key) ? hash[last_key] += value : hash[last_key] = value
  end
end