arr = [1,2,3,4,5,6,7,8,9,10]

# 1.
#
# arr.each {|x| puts x}


# 2.
#
# arr.each {|x| 
# if x > 5
#  puts x
# end
# }

# 3. 
secondArr = Array.new(arr.select {|x| x.odd?})
# puts secondArr

# 4. 
secondArr.push(11)
secondArr.insert(0, 0)
# puts secondArr

# 5. 
secondArr.pop
secondArr.push(3)
# puts secondArr

#6.
secondArr.uniq!
# puts secondArr

#7

# The main difference between a hash and an array is that they allow
# you to use your own objects for the index type instead of integers. 
# ex. test = {question1: "what is the meaning of life", question2: "why is that the meaning of life?"}

#8 

# >= ruby 1.9
test = {question1: "what is the meaning of life", question2: "why is that the meaning of life?"}
# < ruby 1.9 
test = {"question1" => "what is the meaning of life", "question2" => "why is that the meaning of life"}

#9
h = {a:1, b:2, c:3, d:4}
# puts h[:b]

#10
h[:e] = 5
#puts h

#13
h.delete_if {|k, v| v < 3.5 }
#puts h

#14
# They sure can
hash = {nums: [1,2,3,4,5], letters: ["a","b","c","d","e"]}
# puts hash[:nums]

array = [{num: 1, letter: "a"}, 2, 3]
puts array[0]

#15
# i actually really like the ruby-doc documentation, somehow in my univercity experience i 
# never had a professor tell us to study the documentation for a language. I like being all to 
# see a list of everything you can do to the object in one place.
