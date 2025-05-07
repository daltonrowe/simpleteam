module ApplicationHelper
  def deep_search(key, hash)
    match = nil

    if hash.has_key?(key)
      match = hash[key]
    else
      hash.each_pair { |k, v| match = v.respond_to?(:key?) ? deep_search(key, v) : nil }
    end

    match
  end
end
