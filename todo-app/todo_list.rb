require 'yaml'

class TodoList
  attr_accessor :tasks

  def initialize
    @tasks = []
  end

  def add_task(task)
    @tasks << task
  end

  def remove_task(task)
    @tasks.delete(task)
  end

  def complete_task(task)
    task.complete
  end

  def show_tasks
    @tasks.each_with_index do |task, index|
      puts "#{index + 1}. #{task.title} (completed: #{task.completed})"
    end
  end

  def save_to_file(filename)
    File.open(filename, 'w') do |file|
      file.write(YAML.dump(@tasks))
    end
  end

  def self.load_from_file(filename)
    tasks = []
    if File.exist?(filename)
      tasks = YAML.load_file(filename)
    end
    todo_list = TodoList.new
    todo_list.tasks = tasks
    todo_list
  end
end

class Task
  attr_accessor :title, :completed

  def initialize(title)
    @title = title
    @completed = false
  end

  def complete
    @completed = true
  end
end

def print_usage
  puts <<~USAGE
    Usage:
      ruby todo_list.rb [option] [task]
    
    Options:
      -a, --add <task>      Add a new task
      -c, --complete <index>  Mark a task as completed
      -r, --remove <index>    Remove a task
      -l, --list            List all tasks
  USAGE
end

todo_list = TodoList.load_from_file("tasks.yaml")

command = ARGV[0]
task = ARGV[1]

case command
when "-a", "--add"
  if task.nil?
    puts "Please provide a task to add."
  else
    new_task = Task.new(task)
    todo_list.add_task(new_task)
    todo_list.save_to_file("tasks.yaml")
    puts "Task added: #{task}"
  end
when "-c", "--complete"
  if task.nil?
    puts "Please provide the index of the task to mark as completed."
  else
    index = task.to_i - 1
    if index >= 0 && index < todo_list.tasks.length
      task_to_complete = todo_list.tasks[index]
      todo_list.complete_task(task_to_complete)
      todo_list.save_to_file("tasks.yaml")
      puts "Task completed: #{task_to_complete.title}"
    else
      puts "Invalid task index."
    end
  end
when "-r", "--remove"
  if task.nil?
    puts "Please provide the index of the task to remove."
  else
    index = task.to_i - 1
    if index >= 0 && index < todo_list.tasks.length
      task_to_remove = todo_list.tasks[index]
      todo_list.remove_task(task_to_remove)
      todo_list.save_to_file("tasks.yaml")
      puts "Task removed: #{task_to_remove.title}"
    else
      puts "Invalid task index."
    end
  end
when "-l", "--list"
  todo_list.show_tasks
else
  print_usage
end