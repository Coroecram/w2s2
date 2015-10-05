class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss=nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss

    unless boss.nil?
      boss.subordinates << self
    end
  end

  def bonus(multiplier)
    salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :subordinates

  def initialize(name, title, salary, boss=nil, subordinates=[])
    super(name, title, salary, boss)
    @subordinates = subordinates
  end

  def bonus(multiplier)
    all_subordinates.map {|sub| sub.salary}.inject(&:+) * multiplier
  end

  def all_subordinates
    subordinates.map do |sub|
      if sub.is_a?(Manager)
        [sub] + sub.all_subordinates
      else
        sub
      end
    end.flatten
  end

  def sum(array)
    array.inject(&:+)
  end

end

ned = Manager.new("Ned", "Founder", 1000000)
darren = Manager.new("Darren", "Founder", 78000, ned)

shawna = Employee.new("Shawna", "Founder", 12000, darren)
david = Employee.new("David", "Founder", 10000, darren)
p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)
