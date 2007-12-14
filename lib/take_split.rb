module Enumerable
  def take_split n, *a
    t1 = []
    t2 = nil
    self.each_with_index do |i, idx|
      if idx % n == 0
        t2 = [i]
        t1.push(t2)
      else
        t2.push(i)
      end
    end
    if !a.empty?
      t2.concat Array.new(n-t2.size, a[0])
    end
    t1
  end
end
