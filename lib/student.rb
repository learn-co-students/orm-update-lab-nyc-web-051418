require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id


  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      sql2 = <<-SQL
        SELECT last_insert_rowid()
        FROM students
      SQL

      @id = DB[:conn].execute(sql2)[0][0]
    end

  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    Student.new(name, grade, id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name)[0]
    #binding.pry
    self.new_from_db(row)
  end

  def update
    if !self.id
      self.save
    else
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?;
    SQL
    end

    DB[:conn].execute(sql, @name, @grade, @id)

  end

end
