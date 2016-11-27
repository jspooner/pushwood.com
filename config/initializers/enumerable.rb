module Enumerable
  def reorder_by(order, &key_proc)
    index_to_obj = inject({}) do |hash, obj|
      hash[key_proc.call(obj)] = obj
      hash
    end
    order.map do |x|
      index_to_obj[x]
    end
  end
end