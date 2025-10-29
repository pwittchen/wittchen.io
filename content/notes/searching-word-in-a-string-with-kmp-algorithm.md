---
title: Searching word in a string with KMP algorithm
date: 2015-07-22 13:03:00
tags:
- java
---

Sometimes it's good to revise some algorithms and try to implement them in order to get to know, how the built-in functions of high level programming languages actually works. One of the popular problems is [string searching](http://en.wikipedia.org/wiki/String_searching_algorithm). We have many approaches to solve this problem. For example:

*   Naive string search algorithm
*   Rabin-Karp string search algorithm
*   Finite-state automaton based search
*   Knuth-Morris-Pratt algorithm
*   Boyer-Moore string search algorithm
*   Bitap algorithm

This time, I've decided to focus on [Knuth-Morris-Pratt (KMP) algorithm](http://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm). It's quite easy to implement, when you understand it. In addition, its time complexity is quite good and can be defined as _O(n)_. In this algorithm, we simply go through all letters in a given string and compare them with searched string. When position of searched string reaches length of searched string, we can assume, that our string was found. If two compared letters are different, we set position of searched string to zero and start new search from the next position after which we started searching process before. It's quite good described on [Wikipedia](http://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm) with some pseudo-code. You can also take a look at my code in Java available below, which I've written just for practice. 

```java
public class Main {
    public static void main(String args[]) {
        String givenString = "ABC ABCDAB ABCDABCDABDE";
        String searchedString = "ABCDABD";
        int givenStringLetterPosition = 0;
        int searchedStringLetterPosition = 0;
        int foundAt = -1;

        while (givenStringLetterPosition < givenString.length()) {
            if (givenString.charAt(givenStringLetterPosition) == searchedString.charAt(searchedStringLetterPosition)) {
                if(searchedStringLetterPosition == 0) {
                    foundAt = givenStringLetterPosition;
                }
                searchedStringLetterPosition++;
                givenStringLetterPosition++;
                if(searchedStringLetterPosition == searchedString.length()) {
                    System.out.println("String found at " + foundAt + " position.");
                    break;
                }
            } else {
                searchedStringLetterPosition = 0;
                foundAt++;
                givenStringLetterPosition = foundAt;
                if(givenString.length() == givenStringLetterPosition) {
                    System.out.println("String was not found.");
                    break;
                }
            }
        }
    }
}
```

Result of the execution of this program should be as follows: 

```
String found at 15 position.
```

Please note, that we count position of the letter from zero like in the most cases in Computer Science.
