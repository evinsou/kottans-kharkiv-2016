class Object
  def try(*args, &block)
    return if self.nil?

    if args.empty? && block_given?
      return self.instance_eval(&block) if block.arity.zero?

      yield(self)
    else
      meth_name, other = args
      self.send(meth_name, other, &block) if self.respond_to?(meth_name)
    end
  end
end
