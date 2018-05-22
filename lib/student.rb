require 'pry'

require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(name,grade,id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    x = DB[:conn].execute(sql)
    # binding.pry
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
      # binding.pry
    else
      sql = <<-SQL
        INSERT INTO students(name,grade)
        VALUES(?,?)
      SQL
      DB[:conn].execute(sql,self.name,self.grade)

      sql = "SELECT MAX(Id) FROM students"
      @id = DB[:conn].execute(sql)[0][0]
      # binding.pry
    end
  end

  def self.create(name,grade)
    student = self.new(name,grade)
    student.save
    # binding.pry
  end

  def self.new_from_db(row)
    @id = row[0]
    @name = row[1]
    @grade = row[2]
    student = self.new(@name,@grade,@id)
    # binding.pry
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * from students
    SQL
    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
    # binding.pry
  end

end
