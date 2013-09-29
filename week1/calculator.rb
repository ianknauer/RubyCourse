puts "Hello... i am a calculator. Please give me your first number"
num1 = gets.chomp
puts "Excellent, now give me your second number"
num2 = gets.chomp
puts "Now.. What would you like to do to it? 1) add 2) subtract 3) multiply 4)divide"
operator = gets.chomp

if operator == "1"
  solution = num1.to_i + num2.to_i
elsif operator == "2"
  solution = num1.to_i - num2.to_i
elsif operator == "3"
  solution = num1.to_i * num2.to_i
else operator == "4"
  solution = num1.to_f / num2.to_f
end
puts "and your solution is......... #{solution}"
