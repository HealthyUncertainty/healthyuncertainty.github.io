---
layout: page
title: Chapter 3
permalink: /RGuide/Chapter3
---

# Chapter 3 - Some Basic Commands in R
### 3.1 - Creating and Manupulating Objects
R uses what is called ‘object-oriented’ programming. What this means is that R allows you to create and define any health state or transition as an object that can be called up and manipulated. The most simple object that R creates is a ‘vector’, which can be thought of simply as a string of values that you define.

Let’s try creating an object now. Let’s create a vector called “test”, and give it an arbitrary value of 100. The code for this process couldn’t be much simpler[^1] :
~~~
13	test <- 100
~~~
[^1]: **A quick word about coding:** The name of an object/variable can be pretty much anything, except the name of a function. For example, it would be a bad idea to call our made-up object “sample”, since “sample” is the name of a function. After that, all that matters is making sure that when you reference your object later, you’re using the correct name. Also, it’s generally a good idea to give each object a unique name, rather than re-using names you’ve used before in the same program. R will simply write over previous definitions of an object. If, for example, we had called ‘test_2’ by the name ‘test’, then our original value for ‘test’ would be lost – replaced by the new value. Giving them unique names helps prevent confusion. Try it for yourself and you’ll see what I mean.


The '<-' operator is important. It tells R to assign the value on the *right* of the arrow to an object on the *left* side. Other programs (like SAS) may use the '=' character for this operation. Now let’s imagine we have abysmal memory and can’t remember what value we gave our vector. We can ask R to give us the value simply by entering its name in the command line:
~~~
14	test
~~~

And R returns the following:
~~~
[1] 100
~~~

That means that ‘test’ is a vector with one value, and that value (at position [1]) is 100.

An important thing to know about R that is different from some other software packages is that all commands are case sensitive. Let’s look at what happens when we ask R for the value of ‘Test’ (note the capitalization):
~~~
>Test
Error: object 'Test' not found
~~~
This is important to remember when asking R to do something with an object you’ve created, but it’s also crucial when using certain functions that have capital letters in weird places. Your ‘spelling’ must be exact, or R will return an error.

We can also give a vector multiple values. Let’s create an object (called ‘test_2’) [^3]  that is a list of 5 random numbers between 0 and 10:
~~~
16	test_2 <- sample(0:10, 5, replace=T)
~~~

We’ve asked R to ‘sample’ 5 integers between 0 and 10 (‘0:10’), and allow duplicates (that’s what ‘replace=T’ means). Here’s what it gives us:
~~~
17	test_2
[1] 6 5 8 9 2
~~~
It may be worthwhile to note that because these numbers are randomly sampled, if we submitted line 4 again, we’d most likely get a string of 5 different numbers. In fact, if you’re running this code yourself, you’re almost certain to have different numbers for ‘test_2’.

It’s definitely worthwhile to note that we can create new objects by doing math to existing objects. For example, let’s try some very simple things with the two objects we’ve created:
~~~
19	test + test_2
20	test*test_2
21	test/test_2
~~~
When we submit the above lines, R gives us:
~~~
[1] 106 105 108 109 102
[1] 600 500 800 900 200
[1] 16.66667 20.00000 12.50000 11.11111 50.00000
~~~
As you can see, once we’ve defined values for ‘test’ and ‘test_2’, R treats them as objects that can be combined in various ways. We can also create new objects based on ones we’ve previously created. So, for example, if we wanted to create an object called ‘test_3’ that was the sum of ‘test’ and ‘test_2’ (i.e., line 7), we could do that like this:
~~~
23	test_3 <- test + test_2
~~~
Let’s look at our new object:
~~~
24	test_3
[1] 106 105 108 109 102
~~~

So we’ve successfully defined ‘test_3’ as an object with 5 values, those values being the sum of ‘test’ and ‘test_2’. We could have done the same for any mathematical expression.

The last thing I want to work through before we move on to the next section is called ‘concatenation’. In essence, this is simply the process of sticking two things together, end to end. If we wanted to concatenate our first two objects, we could do it this way:
~~~
25	c(test, test_2)
[1] 100   6   5   8   9   2
~~~

We now see a vector with six values (rather than 5). The values correspond to ‘test’, and then all 5 values of ‘test_2’. Let’s see what happens when we do it backwards:
~~~
26	c(test_2, test)
[1]   6   5   8   9   2 100
~~~

Similar result, but now the 5 values of ‘test_2’ (in the same order as always) come before ‘test’. It’s important to keep in mind that we could have defined a new object (named, for example, ‘test_4’) to represent this new list of 6 values: 
~~~
test_4 <- c(test, test_2)
~~~
Either way, we’d get the same output.

Now that we’ve covered the basics of creating and manipulating objects, let’s talk about how we build our health states.

### 3.2 - Working with Arrays in R

The entirety of my approach to building Health State Transition models in R rests on the use of arrays. Arrays are, put simply, tables with multiple dimensions that serve as health states. Arrays have a size that you can define, and we can use their properties to ‘hold’ numbers.

For reasons that will be explained later, most of the arrays we use in programming Health State Transition models are either two-dimensional or three-dimensional. I am a visual guy, so here’s an (extremely poor) illustration of a ‘3x3’ 2-dimensional array:


![alt text][2DArray]

[2DArray]: https://www.dropbox.com/s/si6nxwx97jr9f2z/3_1%202D%20Array.jpg?dl=1 "A 2D Array"
 
And here’s one of a ‘3x3x3’ 3-dimensional array:

![alt text][3DArray]

[3DArray]: https://www.dropbox.com/s/helqwzgu00fubgd/3_1%203D%20Array.jpg?dl=1 "A 3D Array"
 
I use the term ‘slices’ for the third axis (the vertical axis in the illustration).

Making arrays in R is fairly straightforward. We’re going to have an ‘array’ statement, we’ll specify a starting value for all cells, we’ll describe the dimensions of the array, and then we’ll name the dimensions. Let’s create a ‘3x3’ 2-dimensional array [^2], and call it ‘test2d’ [^3]:

[^2]: R also has a function called ‘matrix’ that creates 2-dimensional arrays. The syntax (the order of the commands) is a bit different, but the result is the same. The ‘matrix’ function only creates 2-dimensional arrays, so it’s somewhat less useful.

[^3]:**A note about multi-line statements:** R allows you to have a statement that includes line breaks. R will start reading a line where you tell it to, and won’t finish submitting that line until it reaches a part of the code that concludes the statement. This is useful to know so you don’t have to put all of your code on a single line that goes longer than the width of the window or the page. It’s also handy to know when you’re running your code: sometimes you’ll hit “Run” and the editor will stop on a line that starts with a “+” instead of a “>”. This means that R hasn’t found the conclusion of the statement yet. This usually means you have parentheses or brackets that aren’t closed properly – i.e., you have a ‘(‘ or a ‘[‘ without a corresponding ‘)’ or ‘]’.

~~~
13	test2d <- array(0,dim=c(3,3), dimnames=list(
14	          c("X1","X2","X3"),
15	          c("Y1","Y2","Y3")   ))
~~~
As you can see, we’ve created the array as an object. We concatenate the dimensions and the names for the dimensions. Let’s see what our output looks like:
~~~
16	test2d
      Y1 Y2 Y3
   X1  0  0  0
   X2  0  0  0
   X3  0  0  0
~~~
Our ‘test2’ array is a 3x3 table with default values of 0 [^4]. It has 3 rows – X1, X2, and X3. There are also 3 columns – Y1, Y2 and Y3.

[^4]: It’s up to you if you want to include a default value or not. I do it because R gives the cells a default value of ‘NA’ otherwise, and ‘NA’ does weird things to your math if you’re not careful. The default value could be anything you want, including ‘NA’. You also don’t have to name your dimensions if you don’t want to. Sometimes it’s useful (especially while trying to illustrate something like this), other times it’s cumbersome.


We can use pretty much the exact same set of commands to produce a 3-dimensional array, which I will call ‘test3’:
~~~
18	test3d <- array(0,dim=c(3,3,3), dimnames=list(
19	          c("X1","X2","X3"),
20	          c("Y1","Y2","Y3"),
21	          c("Z1","Z2","Z3")   ))
~~~
When we look at this array, it’s a bit different:
~~~
22	test3
     , , Z1

       Y1 Y2 Y3
    X1  0  0  0
    X2  0  0  0
    X3  0  0  0

    , , Z2

       Y1 Y2 Y3
    X1  0  0  0
    X2  0  0  0
    X3  0  0  0

    , , Z3

       Y1 Y2 Y3
    X1  0  0  0
    X2  0  0  0
    X3  0  0  0
~~~
R displays 3-dimensional arrays as a series of 2-dimensional arrays – one array for each slice. As above, the rows, columns, and slices are all labeled, and all the cells have a value of 0.

Now that we’ve created our blank arrays, let’s give them some values. First, we need to get a handle on how R denotes arrays. We’re going to stick to our 3-dimensional array for now. R uses the following notation to describe the values in arrays:
`ArrayName[X,Y,Z]`

Where ‘ArrayName’ is the name of the array object (‘test3’, for example), and where ‘X’, ‘Y’ and ‘Z’ are the rows, columns, and z-dimensions respectively.

So if we wanted to refer to just the first row in ‘test3d’, we would enter:
~~~
24	test3d[1,,]
~~~
This tells R to return all of the values from row 1 of the X dimension, for all values of Y and Z – that’s what the blanks after the commas (“[1,,]”) corresponds to. Because our array has three dimensions, each time we reference something in the array we have to ensure that we’re specifying what we want to happen with *each* dimension [^4].

[^4]: If we had built a four-dimensional array (which I’ve never had to do, but theoretically one might have to), our way of specifying a cell would have to have four numbers: [1,,,] or [1,3,,] or [2,1,5,4] or [,,,] and so on.

This is the result, but it’s not terribly helpful yet:
~~~
   Z1 Z2 Z3
Y1  0  0  0
Y2  0  0  0
Y3  0  0  0
~~~
Because all of the cells in our array are the same, it’s hard to interpret what we’re looking at. Let’s start by giving our array some numbers. We’ll tell R to populate the X dimension of our array with a sample of integers between 1 and 100:
~~~
26	test3d[1,,] <- sample(1:100, 9, replace=T)
~~~
This tells R to pick 9 numbers at random between 1 and 100, and assign those numbers to the cells in the first row of the X dimension. The output looks like this:
~~~
>test3d[1,,]

   Z1 Z2 Z3
Y1 38 48  8
Y2 95  6 35
Y3 92 44 29
~~~
Which isn’t that much more helpful than when it was all zeroes, but if we look at the whole array, the picture changes a bit:
~~~
>test3d

, , Z1

   Y1 Y2 Y3
X1 38 95 92
X2  0  0  0
X3  0  0  0

, , Z2

   Y1 Y2 Y3
X1 48  6 44
X2  0  0  0
X3  0  0  0

, , Z3

   Y1 Y2 Y3
X1  8 35 29
X2  0  0  0
X3  0  0  0
~~~
Now the picture becomes a bit clearer. The first row of the X dimension is populated by our random numbers, while the second and third rows stay at zero. We can repeat this process for the other rows. For ease of visual inspection, I’m going to give each row a different range of values:
~~~
27	test3d[2,,] <- sample(1000:10000, 9, replace=T)
28	test3d[3,,] <- sample(10001:1000000, 9, replace=T)
~~~
 
And now our array looks like this:
~~~
>test3d
, , Z1

       Y1     Y2     Y3
X1     38     95     92
X2   6639   3235   4043
X3 834088 262629 491049

, , Z2

       Y1     Y2     Y3
X1     48      6     44
X2   6696   5822   3993
X3 736291 318601 119264

, , Z3

       Y1     Y2     Y3
X1      8     35     29
X2   4257   5559   5170
X3 442848 469705 384749
~~~

Each cell is populated with a set of random numbers with different ranges. I chose to use the X dimensions completely arbitrarily. I could have just as easily done this using the Y dimension:
~~~
30	test3d[,1,] <- sample(1:100, 9, replace=T)
31	test3d[,2,] <- sample(1000:10000, 9, replace=T)
32	test3d[,3,] <- sample(10001:1000000, 9, replace=T)
~~~
Now we’re populating columns 1, 2, and 3 with random numbers, and the resulting array looks like this:
~~~
>test3d

, , Z1

   Y1   Y2     Y3
X1 86 5216 567676
X2 59 4070 348204
X3 39 6108 160252

, , Z2

   Y1   Y2     Y3
X1 66 6789 181815
X2  8 3067 529587
X3 87 7520 449565

, , Z3

   Y1   Y2     Y3
X1 25 5120 742742
X2  5 1433  10479
X3 64 2454 180481
~~~
As you can see, now the numbers are sorted based on the columns, rather than the rows, with the smallest numbers in the first column (‘Y1’) and the largest ones in the third column (‘Y3’). We could just as easily have chosen the Z dimension to illustrate this effect.

Of course, we don’t have to populate an array based on the rows or columns at all. We could simply tell R to input randomly-drawn numbers into all 27 cells of the array:
~~~
34	test3d[,,] <- sample(1:100, 27, replace=T)
~~~
And our output looks like this:
~~~
>test3d

, , Z1

   Y1 Y2 Y3
X1 15 10  7
X2 92 61 59
X3  2 91  6

, , Z2

   Y1 Y2 Y3
X1 12 47  9
X2 31 66 37
X3 85 62  9

, , Z3

   Y1 Y2 Y3
X1 87 59 34
X2 64 67 10
X3 91  5 81
~~~
All of the cells in the array have randomly-drawn values between 1 and 100, with no particular order or pattern between the X, Y, and Z dimensions.

Bored yet? Just a couple more quick things and then we’ll move on.

First, you’ll notice that for lines 26-32, I asked R to draw 9 numbers, but in line 34 I asked for 27 numbers. The number of elements we’re putting in the array has to match the number of possible values for the array. In a 3x3 array, that number is 9, and it’s 27 for a 3x3x3 array. If we use the wrong number, R returns an error:
~~~
>test3d[1,,] <- sample(1:100, 12, replace=T)

    Error in test3d[1, , ] <- sample(1:100, 12, replace = T) : 
     number of items to replace is not a multiple of replacement length
~~~
What this error message means is that R is trying to fit 12 numbers into an array that only has space for 9. And it doesn’t like it. At all.

We can also specify more than one dimension at a time. Let’s say we wanted to change the second row of the third column of our array. No problem, the syntax is pretty much the same:
~~~ 
36	test3d[2,3,] <- 999

>test3d

, , Z1

   Y1   Y2   Y3   
X1 15   10   7  
X2 92   61   999
X3 2    91   6  

, , Z2

   Y1   Y2   Y3   
X1 12   47   9  
X2 31   66   999
X3 85   62   9  

, , Z3

   Y1   Y2   Y3   
X1 87   59   34 
X2 64   67   999
X3 91   5    81 
~~~
Our arbitrary value of “999” is now in the second row of the third column. If we wanted to assign a value to a single cell, we’d just take it one step further and specify that one cell.

Finally, I want to talk about two functions that we’re going to be using later in this series. They’re called ‘colSums’ and ‘rowSums’. Let’s define another 3-dimensional array with random numbers between 0 and 100. We can give it the same name.
~~~
34	test3d[,,] <- sample(1:100, 27, replace=T)

>test3d

, , Z1

    Y1 Y2 Y3
X1  49 51 53
X2  82 54 86
X3 100 20 35

, , Z2

    Y1 Y2 Y3
X1  31 26 89
X2  35 43 33
X3 100 30 87

, , Z3

   Y1 Y2 Y3
X1 39 90 43
X2 65 23  8
X3 13 91 51
~~~

If we wanted to calculate the sum of all the numbers in the X dimension (across the other two dimensions), we could enter the following:
~~~ 
38	colSums(test3d)

        Z1  Z2  Z3
    Y1 231 166 117
    Y2 125  99 204
    Y3 174 209 102
~~~
This output tells us that the sum of all X values in the first column and first z-dimension (‘Y1’ and ‘Z1’) is (49 + 82 + 100 =) 231. For ‘Y3’ and ‘Z2’, the sum is (89 + 33 + 87 =) 209, and so on.

As before, we can specify a specific row that we want to see the column sum for:
~~~
39	colSums(test3d[1,,])

    Z1  Z2  Z3 
    153 146 172 

40	colSums(test3d[2,,])

    Z1  Z2  Z3 
    222 111 96 
~~~
The first set of numbers represents the sum of all the values in row 1, across all three z-dimensions. For example, for X=1, Z=1, the sum is (49 + 51 + 53 =) 153, and so on.

The ‘rowSums’ function does the same process, except it gives you the row sum rather than the column sum:
~~~
41	rowSums(test3d)

     X1  X2  X3 
    471 429 527 

42	rowSums(test3d[1,,])

     Y1  Y2  Y3 
    119 167 185 
~~~
The first set of numbers is the sum of all numbers in each X row. So, for ‘Z1’, the number is (49 + 51 + 53 + 31 + 26 + 89 + 39 + 90 + 43 =) 471. The second set of numbers tells you the sum of all the numbers in row ‘X1’, which works out to (49 + 31 + 39 =) 119 for column ‘Y1’.

We’ll use ‘colSums’ much more than we’ll use ‘rowSums’, but it’s useful to know that these functions are there.

Now we’re going to move on to the process of defining random draws from a statistical distribution.

### 3.3 - Generating Random Numbers
We are going to need to be able to tell R to generate a list of random numbers from a statistical distribution to properly build a model. Luckily, this process is quite simple.

Let’s say we wanted a list of 10 numbers based on a normal distribution with a mean of 25 and a standard deviation of 5. We can do all of that in one line:
```
13	test <- rnorm(10,25,5)
```

In this case, ‘test’ is an object that is made up of 10 random values samples from a normal distribution with a mean of 25 and a standard deviation of 5. R returns the following[^5] :

[^5]: This sort of goes without saying, but if you run the code it will produce different numbers because it’s a random draw.
~~~
>test

[1] 22.04445 25.56237 32.86718 29.68062 19.22240 29.57411 31.55188 28.42190 21.75177 29.43259
~~~

Let’s take a look at what this looks like by graphing it in a histogram:
~~~
>hist(test)
~~~
![alt text][hist1]

[hist1]: https://www.dropbox.com/s/h73016gdsh7gyyd/3_3%20Simple%20histogram.jpg?dl=1 "A histogram of the outputs"

 
Okay. Not terribly interesting. Let’s try making a longer list with the same mean and standard deviation.
~~~
16	test2 <- rnorm(1000,25,5)
~~~

I won’t print the output, since it would be a string of 1000 numbers, and you probably know what numbers look like. I will, however, print the resulting histogram:

![alt text][hist2]

[hist2]: https://www.dropbox.com/s/xwe2b2d0fvzdvy3/3_3%20Larger%20histogram.jpg?dl=1 "Another histogram of the outputs"
 
Exactly as we’d expect, we see a normally-distributed set of numbers with a mean of ~25. We can verify this easily. The ‘summary’ function will give us max/min values, along with 25%, 50%, and 75% quantiles, and the mean for a vector. We can also specify specific quantiles we’re interested in (5% and 95%, in this case) using the ‘quantile’ function:
~~~
17	summary(test2)
18	quantile(test2, c(0.05, 0.25, 0.5, 0.75, 0.95))

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  10.58   21.63   25.30   25.10   28.34   43.49 

      5%      25%      50%      75%      95% 
16.99004 21.62641 25.30189 28.33707 33.22588 
~~~

So we know that the lowest value in our randomly-generated function is 10.58, the highest value is 43.49, and that 95% of the observations are between 16.99 and 33.23.

There is a similar function to draw random numbers from a beta distribution called, unsurprisingly, ‘rbeta’. Unlike ‘rnorm’, where you can specify the mean and standard deviation directly, ‘rbeta’ requires you to use shape parameters called ‘shape1’ and ‘shape2’. These values are related to the mean and standard deviation that we often see published in a model’s parameter tables, but they are not the same.

What I typically do is write a simple function (set of instructions in R) to convert mean and standard deviation into ‘shape1’ and ‘shape2’. I’ll talk more about that function and how I use it when we get to subsequent chapters.

There’s an ‘rgamma’ function too, which works very similarly to the ‘rbeta’ function, so again I won’t bother going over it. We will use it later, so for now you can simply note its existence and we can move on [^6].

[^6]: There are functions to draw from many other distributions as well, but we won’t need to use them for this guide.

### 3.4 - Using 'for' Loops in R
The single command that we will be using most often in building our models is the ‘for’ statement. This command tells R to perform some actions when a given condition is met, repeatedly iterating over a set of sequential values. In other words, it repeats what you tell it to do *N* times between 1 and *N*. It’s incredibly versatile, but we’ll focus on a specific application in arrays.

First, let’s create an array of zeroes with 10 rows, one column, and one slice:
~~~
13	test <- array(0, dim=c(10,1,1))

>test
, , 1

      [,1]
 [1,]    0
 [2,]    0
 [3,]    0
 [4,]    0
 [5,]    0
 [6,]    0
 [7,]    0
 [8,]    0
 [9,]    0
[10,]    0
~~~
Let’s also create some objects called ‘start’ and ‘finish’[^1] , with values of 1 and 10 respectively:
[^1]: I have used ‘start’ and ‘finish’ for descriptive reasons. You could use any variable name you like: ‘apples’ to ‘oranges’, or even ‘fight_for_your_right’ to ‘party’. It’s not important. You don’t even have to create names for them. I could have just as easily written ‘for (x in 1:10)’ in line 18, and R would have done the same thing.
~~~
15	start <- 1 
16	finish <- 10

>start
[1] 1

>finish
[1] 10
~~~
What we’re going to tell R to do now is assign values to our array ‘test’, for all rows between ‘start’ and ‘finish’ [^2]:
[^2]: I have chosen to organize the curly brackets in this way for ease of readability, but I could have very well put that entire expression on a single line of code. You can do multiple commands within the same loop, as long as each command is written on a new line. Don’t worry if that doesn’t make sense right now: we’ll have plenty of encounters with ‘for’ in later sections of this guide.
~~~
18	for (x in start:finish){
19	    test[x,,] <- x^2
20	}
~~~

Note that there are three different types of brackets used in this statement. The round brackets are used to specify the contents of the ‘for’ function, the curled brackets are used to tell R where the loop starts and ends, and the square brackets are used in specifying values in the array. Note also that ‘x’ is an arbitrary name for some variable.
Let’s look at the output:
~~~
>test
, , 1

      [,1]
 [1,]    1
 [2,]    4
 [3,]    9
 [4,]   16
 [5,]   25
 [6,]   36
 [7,]   49
 [8,]   64
 [9,]   81
[10,]  100
~~~
Each row between the ‘start’ value of 1 and the ‘finish’ value of 10 is the square of the row number in ascending integer sequence.

Now, what happens if we repeat this whole process, but change the value of ‘start’ and ‘finish’? Let’s set ‘start’ equal to 3, and ‘finish’ equal to 7.
~~~
23	test2 <- array(0, dim=c(10,1,1))
24	start2 <- 3
25	finish2 <- 7
26	for (x in start2:finish2){
27	    test2[x,,] <- x^2
28	}
~~~

Look at how the output has changed:
~~~
>test2
, , 1

      [,1]
 [1,]    0
 [2,]    0
 [3,]    9
 [4,]   16
 [5,]   25
 [6,]   36
 [7,]   49
 [8,]    0
 [9,]    0
[10,]    0
~~~
Cells that lie outside the range of ‘start2’ and ‘finish2’ remain at zero (the specified default value for this array). Cells inside the range have values as described by line 26-28.

The last thing I want to do with this function is illustrate the most important thing we can do with it: we can make the value of a cell contingent on the value of another cell in the array. Let’s say, for example, that we wanted the array to be equal to the square of the value of the previous line plus 1, between some arbitrary ‘start’ and ‘finish’ rows:
~~~
31	test3 <- array(0, dim=c(10,1,1))
32	start3 <- 4
33	finish3 <- 9
34	for (x in start3:finish3){
35	    test3[x,,] <- 1 + test3[(x-1),,]^2
36	}
~~~
We’re applying the function between a ‘start’ value of 4 and a ‘finish’ value of 9. Let’s look at the output:
~~~
test3
, , 1

        [,1]
 [1,]      0
 [2,]      0
 [3,]      0
 [4,]      1
 [5,]      2
 [6,]      5
 [7,]     26
 [8,]    677
 [9,] 458330
[10,]      0
~~~
Let’s break down what R has done. Since the first three rows are outside the range of ‘start’, R does nothing and leaves them at the default value of zero. For row 4, which is inside the range we’ve specified, R looks up the value of ‘test3’ in row ‘x-1’. When ‘x’ is 4, ‘x-1’ is 3, so R uses the value from row 3 (which, in this case, happens to be 0). R then applies the formula in line 36: (1 + 0^2 =) 1.

R now repeats this process for the next row. When ‘x’ is 5, ‘x-1’ is 4, so R takes the value from that row (which, in this case, is 1) and applies the formula again: (1 + 1^2 =) 2. In line 6, the formula becomes (1 + 2^2 =) 5. Line 7 is: (1 + 5^2 =) 26, and so on. Because line 10 is outside the range of ‘start3’ to ‘finish3’, the default value of 0 remains.

There will be more R functions that we’ll have to use as we go along, but these are the basic ones that we’ll be using the most, and that will power the rest of the process.

In the next chapter, we're going to pull all these different ideas together and apply them to building a Health State Transition Model.

### 3.5 - A Note on For Loops

Seasoned programmers in R will no doubt be appalled by the last chapter. Loops are acceptable programming but there are methods out there that are much faster and more concise than my method. This is the primary way in which my modeling approach differs from the one developed by the DARTH group, although there are many others.

I am not a developer nor am I an especially savvy coder. I originally began working on developing this method back in 2011, and didn't have any R developers to assist me. This was also well before I discovered the blossoming R-based modeling community (and, I suspect, not too long after that community started coalescing). As a result, this method doesn't reflect some of the excellent work being done by people who are more skilled than I.

Loops still have a ton of usefulness outside of the context we'll be using them for in this guide, so this knowledge is still useful.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter4_1)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter2)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)