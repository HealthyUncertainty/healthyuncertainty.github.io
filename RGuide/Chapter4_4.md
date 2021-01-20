---
layout: page
title: Chapter 4.4 - Define Inputs and Paramters in R
permalink: /RGuide/Chapter4_4
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.4 - Step 5 - Define Inputs and Parameters in R
-	Step 1: Draft a Model Schematic
-	Step 2: Clinical Validation
-	Step 3: List Model Inputs
-	Step 4: Evaluate Model Inputs
-	**Step 5: Define Inputs and Parameters in R**

For a guide on building models in R, we’ve so far spent very little time actually writing any code. We’re at the point where we can start actually coding. Well, almost. Just a couple more really quick steps. Some of the functions we’re going to want for this model are not included in the default R code, which means we’ll have to download the requisite packages. R Studio has a window on the bottom right with a tab called ‘Packages’:

![alt text][RStudio]

[RStudio]: https://www.dropbox.com/s/gioifcbk0iyk3nx/4_4%20R%20Window.jpg?dl=1 "A screenshot of an RStudio window"
 
Clicking ‘install’ will prompt you to choose a mirror site to download the package you want. The ones you’ll want to make sure you’ve downloaded and installed are: ‘BCEA’, ‘gtools’, and ‘readxl’. All R packages are free to download and use.

Once we’ve downloaded the packages we want to use, we need to load them into R, which is simplicity itself:
~~~
14	### LOAD REQUIRED PACKAGES
15	library(BCEA)
16	library(gtools)
17	library(readxl)
~~~
You’ll notice that line 14 isn’t ‘code’ in the way we’ve seen it up to now. R allows you to ‘annotate’ your code with lines that start with hashmark symbol (“#”). Anything on a line that starts with a hashmark will not be read as a command for R to do something. This is generally considered good practice when writing any kind of code: explain what you’re doing as you do it. That way, if you are swallowed by a T-Rex on your way to the office, your grieving colleagues can still run your code as a posthumous testament to your genius-level R programming skills.

On a serious note, annotating your code allows you (or someone else) to easily recognize the purpose of each section. It’s also good for leaving yourself (or someone else) a note about something you’re uncertain about, something you’ve had to ‘fix’ in an innovative way, or basically adding clarity to any part of your code that warrants it. It’s a good habit to get into, especially if there’s a chance that anyone else will be reading your code.

Now that we’ve loaded the packages we need, there’s one more thing we need to do before we can start coding. We’ll need to import the values we’ve placed in our table. The first step is to identify what R calls the “working directory”. This tells R where the table is saved. So we set the working directory [^1]:

[^1]: The process on a Mac is a bit different, and I have no idea how it works on a Linux or other OS machine. I’d imagine it’s fairly similar.

~~~
19	### SET WORKING DIRECTORY
20	setwd("WHATEVER DIRECTORY YOU'VE SAVED THESE FILES IN")
~~~
 
And now that we’ve set the working directory, we can read in the table [^2]:
[^2]: You'll need to have your Excel file saved in the working directory.

~~~
22	### READ IN VALUES FROM TABLE
23	Source <- read.excel("Model Inputs.xls")
24	Inputs <- subset(Inputs, Value >-1)
~~~

In the code above, I’ve created a vector called ‘Inputs’ to store the data from the table. This step isn’t strictly necessary, but it makes things a bit less cumbersome. I’ve then removed all of the variables that are calculated later in the code (our returning variables) by telling R to only use variables with a value larger than -1.0 . Let’s take a look at our newly-created object:

~~~
> Inputs
# A tibble: 13 x 6
   Parameter Type   Description                           Value    Error
1      P_W_X    1   transition from state W to state X     0.30    0.050
2      P_X_W    1   transition from state X to state W     0.05    0.005
3      P_X_Y    1   transition from state X to state Y     0.15    0.030
4      P_Y_Z    1   transition from state Y to state Z     0.67    0.070
8        P_W    2   probability of being ‘sorted’ i...     0.65    0.150
10       C_W    3   cost of being in state W             300.00    60.00
11       C_X    3   cost of being in state X             850.00  200.000
12      C_Yt    3   cost of transitioning into sta...   1500.00  450.000
13       C_Y    3   cost of being in state Y             750.00  115.000
14      C_Zt    3   cost of transitioning into sta...   2500.00 2500.000
15       U_W    4   utility value experienced by...        0.95    0.070
                                    ...
~~~

As you can see, ‘Inputs’ now has all the values from our table, minus the returning ones. We’ve essentially just re-created the .xls file as an R object. Note, however, that I have not bothered to define the variables that are defined as 100% minus the value of some other variable (for example, P_Yreturn or P_X). We will do this later in the chapter, after we have turned these estimates into probabilistic model parameters rather than single data points.

Now that we have the point estimates read in, we need to talk a little bit about Probabilistic Analysis (sometimes called Probabilistic Sensitivity Analysis or PSA). This book cannot and will not take the place of a formal, rigorous understanding of PSA, but we need to understand at least the ‘point’ of PSA to put the rest of this chapter into context.
 
### Probabilistic Sensitivity Analysis

The reason we call the inputs into our model ‘estimates’ is because they are ‘best guesses’ of what the ‘true’ value is. For example, the cost of spending one cycle in state W (C_W) is estimated at $300. Does that mean that every person who enters into state W is going to generate exactly $300 of costs? Depending on what that state is, not necessarily. If state C involves having a doctor’s appointment and a blood test, that cost is likely to be the same value every time. However, what if state W involves a hospital stay, or a combination of several possible tests that will are different for different people? State costs like that are highly variable.

Furthermore, where do we get the estimate of $300 from? If it’s the mean value of an observational study, we know that the estimate is drawn from a sample, not the full population. That means there’s the possibility that the ‘true mean’ value lies somewhere within a 95% Confidence Interval of our point estimate of $300. The probability that the ‘true mean’ is $275 is much greater than the probability that it is $200, even though both of those values may lie within the confidence interval.
We can use some basic assumptions about the underlying probability distribution for our estimates to run comparisons on a range of values. We can allow all of our model input estimates to vary according to those assumptions, and run our model several times to give us a range of likely values for costs and effectiveness, given that there is uncertainty about the ‘true’ value of each input. This is PSA.

In order to do PSA, we are going to have to define some ‘global’ parameters for the model. These are parameters that are not about the transitions between states, but govern the overall behavior of the model:

~~~
25	### DEFINE GLOBAL PARAMETERS FOR MODEL
27
26	ncycle <- 50  
27	n <- 10000
28	npop <- 1000
29	Disc_O <- 0.015
30	Disc_C <- 0.015
~~~
 
Let’s quickly look at these one at a time:
-	ncycle: This is the number of model cycles (i.e. how many times the model ‘hits the equals button’)
-	n: This is the number of probabilistic draws the model performs (i.e., the number of randomly-sampled estimates the model produces for each input).
-	npop: This is the total number of person-groups in the model [^3]. The value of this estimate is entirely arbitrary, and technically we don’t need to define it at all, but it makes visual inspection and debugging much easier
-	Disc_O: The discount rate for outcomes.
-	Disc_C: The discount rate for costs.

[^3]: I have used the term ‘person-group’ a few times without defining it. If you think of the model as describing the way that ‘people’ move through a series of health states, there has to be a fixed number of ‘people’ that we’re evaluating. However, because we are going to end up with fractions of that number being moved through the model, and you can’t have a fraction of a person (at least not without having some very uncomfortable discussions with the police), it is more helpful to think of them as groups of identical people moving through the model. Hence, ‘person-group’. Ultimately this is a semantic issue rather than something deserving serious consideration.

These values will remain static, and as such will not be part of the PSA. The rest of the values that we’ve imported into ‘Inputs’ will have to be turned into probabilistic estimates, a process that we will devote the rest of this chapter to. It’s also perhaps worth noting that we could (and I often do) specify these values in the ‘Model Inputs’ Excel file. For the purposes of this guide I’m going to define them in the code instead.

##### Generating Probabilistic Parameters
The modeling process is based on creating three-dimensional arrays, with each row representing a model cycle and each slice representing a set of randomly-generated probabilistic values (or an ‘iteration’ of the model). Our model parameters must, therefore, have the identical number of randomly-generated values as there are model iterations. The number of iterations (and concordantly the number of random draws) is defined as ‘n’.

The value of each random draw is described according to an underlying statistical distribution. Because we don’t know the ‘true’ distribution of our values (seeing as we just have point estimates and standard deviations), we will have to make some assumptions about how the values are likely to be distributed. The textbook by Briggs, Claxton and Sculpher gives us some guidance in Chapter 4.
- **Probabilities (Static and Transition)**
Because probabilities must lie between 0% and 100%, we must use a distribution that fits this requirement – the beta distribution.

-	**Costs**
A cost that is less than zero (i.e., a negative cost) is a nonsensical concept. While in an accounting sense, a credit could be thought of as a ‘negative cost’, that is not applicable in this context. We therefore need to choose a distribution that cannot be less than zero, but can have values in excess of zero. This is the gamma distribution.
- **Utilities**
Utility values usually lie between 0.0 and 1.0, but because it is technically possible to have a health state utility that is less than zero (i.e., a state of health where death would be preferable), Briggs *et al* recommend that utilities be described as disutilities – the amount of health utility ‘lost’ by being in a state – and that a gamma or lognormal distribution be used to describe them.

Recall that R handles beta and gamma distributions according to ‘shape parameters’. It is possible to derive the shape parameters of our model inputs based on their means and standard deviations. R doesn’t have a function built in (that I know of) that allows you make this conversion easily, but I’ve written one for you:
~~~
35	### DEFINE SHAPE VARIABLES FOR BETA- AND GAMMA-DISTRIBUTED PARAMETERS
36	bdist <- function(x, y){
37	  alpha <- x*((x*(1-x)/y^2) - 1)
38	  beta <- (1-x)*(x/y^2*(1-x) - 1)
39	    return(t(c(alpha, beta)))} 
40	   
41	gdist <- function(x, y){
42	  shape <- x^2/y^2
43	  scale <- y^2/x
44	    return(t(c(shape, scale)))}
~~~

These functions allow us to convert the point estimates in ‘Inputs’ into distributions suitable for PSA by providing us with the shape parameters we need. Let’s take a look at how they do that.

The transition probability “P_W_X” describes the probability of moving from health state “W” to health state “X” in a given cycle. It has a mean value of 0.3, and a standard deviation of 0.05.

The shape parameters associated with a beta distribution based on those values can be calculated using the ‘bdist’ function:
~~~
>bdist(0.3, 0.05)
     [,1] [,2]
[1,] 24.9 58.1
~~~
PSA values for “P_X_W” can be drawn from a beta distribution with shape parameters 24.9 and 58.1. The output is similar for ‘gdist’, but it is crucially important to note that the function outputs the scale parameter rather than the rate parameter for specifying the distribution. If this distinction doesn’t mean anything to you then don’t worry about it, but if it does then there you go.

We can therefore transform our point estimate for ‘P_WtoX’ into a probabilistic function ‘PR_WtoX’ using these shape parameters:
~~~
PR_W_X <- rbeta(n,24.9,58.1)
~~~

Thus creating ‘n’ values drawn from a beta distribution. These drawn values have a mean and standard deviation approximately equal to the point estimates 0.30 and 0.05, which we can verify easily:
~~~
>mean(PR_W_X)
 [1] 0.3000853
>sd(PR_W_X)
 [1] 0.04935192
~~~
We can also examine this newly-created probabilistic parameter graphically:
~~~
>hist(PR_W_X)
~~~
![alt text][VarOutput]

[VarOutput]: https://www.dropbox.com/s/tugwa3sa2no8vux/4_4%20Variable%20Output.jpg?dl=1 "Logo Title Text 2"

Because our ‘bdist’ function outputs our shape parameters as a 1x2 table, we can call the output from ‘bdist’ the way we would values from any other table. We can, therefore, perform several steps at once and create a list of randomly-drawn values in one line of code:
~~~
test <- rbeta(n,bdist(0.3, 0.05)[,1],bdist(0.3, 0.05)[,2])
~~~
This produces the same random draw, without having to calculate and then manually enter the shape parameters. 

This is still an inelegant way of creating probabilistic variables, though. It requires us to have one line of code for every variable we want. For a small model like ours, that’s not such a big deal. For bigger models, however, this can become time-consuming both to program and to run.
 
A better way to do this is to tell R to create variables based on the values in the table. First, we need to tell R which distribution to use for the different variables. This is where our “Type” column comes in. We can create three new table objects – one for beta-distributed variables, one for gamma-distributed costs, and one for gamma-distributed utilities:
~~~
46	### IDENTIFY VARIABLES BY TYPE
47	Betavars <- subset(Inputs, Type==1 | Type==2)
48	  Betavars["Shape1"] <- 0
49	  Betavars["Shape2"] <- 0
~~~

This set creates a new table called “Betavars” that contains the rows from the “Inputs” table that are either Type 1 or Type 2 (that’s what the “==” does). We also create two new columns to hold our shape parameters that we’re going to calculate momentarily. Let’s take a look:
~~~
> Betavars
# A tibble: 5 x 8
  Parameter Type    Description                           Value Error Shape1 Shape2
1     P_W_X    1    transition from state W to state X     0.30 0.050      0      0
2     P_X_W    1    transition from state X to state W     0.05 0.005      0      0
3     P_X_Y    1    transition from state X to state Y     0.15 0.030      0      0
4     P_Y_Z    1    transition from state Y to state Z     0.67 0.070      0      0
8     P_W      2    probability of being ‘sorted’ i...     0.65 0.150      0      0
~~~

We can repeat this process for cost and utility variables:
~~~
50	Gammavars <- subset(Inputs, Type==3)
51	  Gammavars["Shape1"] <- 0
52	  Gammavars["Shape2"] <- 0
53	Utilvars <- subset(Inputs, Type==4)
54	  Utilvars["Shape1"] <- 0
55	  Utilvars["Shape2"] <- 0
~~~

Now let’s fill those blank “Shape1” and “Shape2” columns. We can use a loop to do this, telling R to use the values in columns 5 and 6 (“Value” and “Error”, respectively) to calculate “Shape 1” and “Shape 2” for each row “i” from row 1 to the last row of the “Betavars” table:
~~~
57	### CALCULATE SHAPE PARAMETERS
58	for (i in 1:nrow(Betavars)){
        Betavars[i,6] <- bdist(Betavars[i,4], Betavars[i,5])[1]
59	Betavars[i,7] <- bdist(Betavars[i,4], Betavars[i,5])[2]}
~~~
Now let’s look at “Betavars” again:
~~~
>Betavars
# A tibble: 5 x 8
  Parameter Type    Description                           Value Error Shape1 Shape2
1     P_W_X    1    transition from state W to state X     0.30 0.050   24.9   58.1
2     P_X_W    1    transition from state X to state W     0.05 0.005  94.95 1804.1
3     P_X_Y    1    transition from state X to state Y     0.15 0.030   21.1 119.57
4     P_Y_Z    1    transition from state Y to state Z     0.67 0.070  29.56  14.56
8     P_W      2    probability of being ‘sorted’ i...     0.65 0.150   5.92  3.189
~~~
As you can see, R has calculated shape parameters for each variable in the table. Once again, we can run the identical code for the other variable types:
~~~
61	for (i in 1:now(Gammavars)){
        Gammavars[i,6] <- gdist(Gammavars[i,4], Gammavars[i,5])[1]
62	Gammavars[i,7] <- gdist(Gammavars[i,4], Gammavars[i,5])[2]}
63 
64	for (i in 1:nrow(Utilvars)){
        Utilvars[i,6] <- gdist(1-Utilvars[i,4], Utilvars[i,5])[1]
65	Utilvars[i,7] <- gdist(1-Utilvars[i,4], Utilvars[i,5])[2]}
~~~

We now have three tables with the shape parameters we’ll need for the PSA . We can tell R to create variables with the names specified in the table (i.e., “P_WtoX”, “C_W”, etc.) and with values based on the shape parameters we’ve calculated. Here’s what that looks like for the beta-distributed variables:
~~~
67 ### PARAMETERIZE POINT ESTIMATES
68	  # Perform random draws based on assumptions about parametric distributions
69	    # Binary probabilities: beta distribution
70	    for (i in 1:nrow(Betavars)){
71	    sh1 <- as.numeric(Betavars[i,6])
72	    sh2 <- as.numeric(Betavars[i,7]) 
73	    assign(paste(Betavars[i,1]), rbeta(n, sh1, sh2))}
~~~

Let’s walk through the code:
-	**for (i in 1:nrow(Betavars)){** - we’re setting up a loop to perform some set of commands for each row, i, in our object called Betavars
- **sh1 <- as.numeric(** - we’re going to define some objects ‘sh1’ and ‘sh2’, based on the numeric values contained within…[^sh1] 
- **Betavars[i,6], Betavars[i,7]** – columns 6 and 7 for each row ‘i’
- **assign(** – we are telling R to create an object with a name and value we will specify inside the brackets
- **paste(** – the name of the variable is going to be ‘pasted’ as a character string from the contents within the bracket
- **Betavars[i,1]** – for each row ‘i’, the name of the variable is contained in column 1.
- **rbeta(n, sh1, sh2))** – each variable will be comprised of ‘n’ randomly-sampled values from a Beta distribution, with shape parameters ‘sh1’ and ‘sh2’

[^sh1]: This step seems unnecessary, and in some ways it is. I’m not going to get into this too much because it’s boring but “readxl” defaults the data into a specific format that requires us to do this ‘as.numeric’ business for the rest of the code to work. There’s probably a smarter way to solve this problem.


The output of this code is the creation of 5 new variables: “P_WtoX”, “P_XtoW”, “P_XtoY”, “P_YtoZ”, and “P_W”, exactly as they appear in the first column of the “Betavars” table. Each variable takes the form of a list of ‘n’ (in this case 10,000) randomly-sampled values from the Beta distribution, with a mean and standard error that match those from the input table.

The code for creating cost variables is very similar:
~~~
75	# Costs: gamma distribution
76	for (i in 1:nrow(Gammavars)){
77	  sh1 <- as.numeric(Betavars[i,6])
78	  sh2 <- as.numeric(Betavars[i,7])
79	  assign(paste(Gammavars[i,1]), rgamma(n, sh1, scale = sh2))}
~~~
The output is similar as well – five vectors filled with randomly-sampled Gamma distributed values.

Recall that for the utilities we are encouraged to randomly sample disutility (i.e., the amount of utility lost by being in a given health state). Our code is slightly different, in this case:
~~~
81	# Utilities: gamma distribution of disutility (1 - utility)
82	for (i in 1:nrow(Utilvars)){
83	  sh1 <- as.numeric(Utilvars[i,6])
84	  sh2 <- as.numeric(Utilvars[i,7]) 
85	  assign(paste(Utilvars[i,1]), (1 - (rgamma(n, sh1, scale = sh2))))}
~~~
The values in the three variables we create with this step are 1.0 minus randomly-sampled disutility. The mean values for all these variables, it’s important to remember, should be approximately equal to the values in the table. You can verify this quickly and easily by entering “mean(VariableName)” into the console. Let’s take an example:
~~~
>mean(U_X)
[1] 0.8496329
~~~
So far, so good. Now there’s the relatively simple task of defining the remaining variables – the returning ones. All we have to do is tell R to set each parameter to be equal to 1 minus the values of the transitions out of that state:
~~~
81	# Define returning parameters
82	P_Wreturn <- 1 - P_WtoX
83	P_Xreturn <- 1 - (P_XtoW + P_XtoY)
84	P_Yreturn <- 1 - P_YtoZ
85	P_X       <- 1 - P_W
~~~

With this step, we create 5 new variables that are returning values of the variables we created in the previous lines of code. We now have all of the variables that we need to populate our model – all we need to do now is tell R how to apply those variables, which will be the subject of our next chapter.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter4_5)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter4_3)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)