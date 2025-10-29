---
title: Adding reversed numbers
date: 2013-01-21 18:51:00
---
In this post I will show you my approach to adding reversed numbers. This problem occurred during the ACM Central European Programming Contest, in Prague in 1998.

General description of the problem
----------------------------------

### Input

The input consists of _N_ cases (equal to about 10000). The first line of the input contains only positive integer _N_. Then follow the cases. Each case consists of exactly one line with two positive integers separated by space. These are the reversed numbers you are to add.

### Output

For each case, print exactly one line containing only one integer - the reversed sum of two reversed numbers. Omit any leading zeros in the output.

### Example

**Sample input:**

```
3
24 1
4358 754
305 794
```

**Sample output:**

```
34
1998
1
```

Solution
--------

### Exemplary approach

1.  In the first line of the input, we put number of the lines to process.
2.  In the next lines, we put numbers split by space, in which we should reverse order of the digits and then add them.
3.  In the final step, we should reverse order of the digits in the generated data and write result to the output.

### Proposal of the solution in the Ruby language

```ruby
def addrev(n)
  b = 0
  n.split(' ').each do |a|
    b+= a.to_s.reverse.to_i
  end
  return b.to_s.reverse.to_i
end

a = true
i = j = 0
out = []

$stdin.each_line do |line|
  if(!a) then
    if(j != i)
      out.push(addrev(line.to_s))
      j += 1
    else
  break
  end
  else
    i = line.to_i
    a = false
  end
end

out.each do |b|
  $stdout << b << "\n"
end
```
