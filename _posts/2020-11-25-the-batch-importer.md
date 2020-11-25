---
title: Batch Importer
subtitle: Import multiple variables in a single step
tags: [R, tools]
---

The first R tool that I'm going to write up is what I call the Batch Importer. I sort of describe an early version of this tool in Chapter 4 of the R Guide, but it's been refined considerably since then.

[**Get the code**](https://github.com/HealthyUncertainty/healthyuncertainty.github.io/blob/master/Tools/BatchImporter/ImportVars.R)

When you read a paper about a cost-effectiveness model, most of them have a table that looks something like this:

![A cost-effectiveness table][cetable]

[cetable]: https://www.dropbox.com/s/dicnki431e3cw0m/cetable.jpg?dl=1

These tables describe all the inputs into the model, and how they are related to parameter values[^1]. They typically describe the uncertainty around each input, most commonly as an expression of error around the mean estimate. This is usually how these values are published in the literature themselves, so if you're building your own model that's almost certainly the information you have available to you.

[^1]: I'm going to try and stick to my personal shorthand that separates model 'inputs' from model 'parameters'. An 'input' in this case is a set of values that get read into the model from an external source, whereas parameters are what the model uses to perform its calculations. Inputs get *turned into* parameters. I hope that makes sense. In plain terms for the context of this post, 'inputs' live in Excel, 'parameters' live in R.

When I first started building models, one of my big frustrations was figuring out "how do I turn a mean and standard deviation into random numbers?" This is straightforward enough for the normal distribution. We can generate some numbers (mean of 100 and SD of 20 chosen arbitrarily):

```r
hist(rnorm(1000, mean=100, sd=20))
```

![A histogram][hist1]

[hist1]: https://www.dropbox.com/s/whkwj3sc9nl5kup/hist1.jpg?dl=1

But R doesn't make it so easy for beta and gamma distributed values. It doesn't allow you to simply use the mean and SD, it instead asks you to specify shape/scale parameters. While those parameters are *sometimes* available in a table summarizing cost-effectiveness model inputs, they're almost *never* available in the literature. You'll have to convert them yourself (which I didn't find to be particularly straightforward, but your mileage may vary).

Once you solve the conversion problem, you run into a different issue. If you want to perform sensitivity analysis and/or test different parameter values, it's highly non-intuitive to be messing around with shape and scale parameters when what you're actually doing is looking at different values of the mean/SD. You'll have to make multiple conversions and then apply those numbers, adding multiple steps to the process of bumping a mean value up/down in order to see how the model responds.

Finally, there is a useability issue. If you're specifying your parameter values in the body of the code, making changes becomes a bit of a hassle: 

```r
# Some imaginary parameters
param1 <- rnorm(n, mean1, sd1)

param2 <- rbeta(n, shape1 = s1param2, shape2 = s2param2) 

param3 <- rbeta(n, shape1 = s1param3, shape2 = s2param3)

...

paramN <- rgamma(n, shape = s1paramN, scale = s2paramN)
```

This might be a snap if the number of parameters is small, but the larger that number gets the more lines of code you have to sift through, find the value you want, make the change that you want (with the converted parameter values!) and then re-run the code. A hassle. Good luck getting with someone who isn't comfortable in R to do that!

So what I've built is a fast and easy way of popping parameter values from the table you're used to seeing in a publication into an R model.

# The Batch Importer

[**Get the code**](https://github.com/HealthyUncertainty/healthyuncertainty.github.io/blob/master/Tools/BatchImporter/ImportVars.R)

**Purpose:** This tool takes input values from an Excel file and converts them into parameter values that can be used for probabilistic analysis.

**Data In:** An Excel file that is formatted to include input names, the mean and error terms, and a number describing variable 'type'.

**Data Out:** A list containing four objects:

- "varname": A list of input names
- "varmean": A list of the mean values (for deterministic analysis)
- "varprob": A list of 'num_iter' probabilistically-sampled values for each parameter, derived from the input mean/se and the type
- "df_psa_input": A dataframe containing "varname" and "varprob" that is formatted to be compatible with ['dampack'](https://github.com/DARTH-git/dampack), the CEA package developed by [DARTH](http://darthworkgroup.com).

**Steps:**

1. Set up your Excel inputs table
2. Import the inputs from Excel into R
3. Define shape variables for beta- and gamma-distributed parameters
4. Define the 'ImportVars' function
5. Run the 'ImportVars' function on your imported values

## Method

### Step 1: Set up your Excel inputs table

All of the inputs into our model are going to be read from a table in Excel. This makes it easy to enter and change values if you want, plus saves your model user (yourself, most likely) from having to mess around in the code. The numbers in this table are totally arbitrary.

![A screenshot of an Excel table][modelinputs]

[modelinputs]: https://www.dropbox.com/s/ubzls9hkwngutp9/modelinputs.jpg?dl=1

If you've read the R Guide, this table will look pretty familiar. There are three relevant differences:

- I've removed the 'returning' inputs because we calculate those within R anyway;
- The inputs 'C_W' and 'C_X' are now normally-distributed instead of Gamma distributed, just for fun; and
- There are two new variable types, '5' (rate ratio) and '9' (fixed value)

It's totally fine to leave the 'Description' column blank, since R doesn't use it for anything. It's just there so you can keep track of which input is which. I also like having a pair of columns in there for the 'baseline' values but these aren't inputs, they're just for your reference in case you change something.

### Step 2: Import the inputs from Excel into R

Once you have your table saved in Excel, we use the 'readxl' package to import the values:

```r
### SET WORKING DIRECTORY (WHERE YOUR EXCEL FILE IS)
  setwd("//mydirectory")

### READ IN VALUES FROM TABLE
  install.packages('readxl')
  library(readxl)
  Inputs <- read_excel("Model Inputs.xls") #The Excel file name
  Inputs <- subset(Inputs, Value >-1) #Remove blank rows
```

Make sure you set 'mydirectory' to be where the Excel model is saved, or you will have to include the full path name in the "read_excel" step (i.e., Inputs <- read_excel("C:/whatever/.../Model Inputs.xls").

As a result of this step, we will have an object called 'Inputs' that contains all the values that are in the Excel table.

### Step 3: Define shape variables for beta- and gamma-distributed parameters

We're going to use the ['method of moments'](https://en.wikipedia.org/wiki/Method_of_moments_(statistics)) approach to estimating the shape/scale parameters. This approximation means we are making some assumptions about the true shape of uncertainty around the paramter's mean. In English, there are many ways that a beta-distributed variable could have a mean of 'X' and a SD of 'Y', and the method of moments just picks one. But, given that we don't *have* any information about the shape of the uncertainty, the method of moments gets us close[^2].

[^2]: if we *did* have information about the shape (i.e., stochastically-derived shape/scale parameters), we could just use those instead of the mean/SD

Here's a pair of functions to do that:

```r
bdist <- function(x, y){
  alpha <- x*((x*(1-x)/y^2) - 1)
  beta <- (1-x)*(x/y^2*(1-x) - 1)
  return(t(c(alpha, beta)))}    
  
gdist <- function(x, y){
  shape <- x^2/y^2
  scale <- y^2/x
  return(t(c(shape, scale)))}
```

This creates two functions: 'bdist' and 'gdist' that take inputs 'x' and 'y', representing the mean and the SD respectively. When you run it, it returns a vector containing the two shape/scale parameters that are needed to perform the probabilistic sampling function for the beta and gamma distribution respectively[^3].

[^3]: Obviously Beta and Gamma are only two of many possible distributions you might want to import from. Hopefully it will be straightforward for you to take the same process for doing the method of moments for those distributions and make your own function so you can apply it to whatever other distribution you're working with. Please let me know if it isn't straightforward and I will write a post about that.

### Step 4: Define the 'ImportVars' function

Here's where the rubber meets the road. We're going to build a function that looks at our Inputs object one row at a time. For each row, it's going to consider the variable type and generate the appropriate shape/scale parameters for that distribution.

```r
ImportVars <- function(input_table, num_iter){
  
  # Create blank lists to hold values
  param_table_names = list()
  param_table_deterministic = list()
  param_table_probabilistic = list()
  # Note the creation of the "temp" variable. This is to give the
  # empty dataframe the correct number of rows. It will be deleted
  # later in the code
  param_dataframe = data.frame(temp = 1:num_iter)
```

First we define our function and ask it to accept two inputs: 'input_table' (our Inputs object) and 'num_iter', the number of probabilistic draws we want to perform. We then ask the function to create some blank lists and a blank dataframe to hold the sampled values. The 'temp' variable is there solely for the purpose of establishing the dimensions of the dataframe. We'll delete it later.

```r
 # Read in the table one row at a time
  for (i in 1:nrow(input_table)){
    var <- input_table[i,]
    varname <- var$InputName
    vartype <- var$Type
    varmean <- var$Value
    varsd   <- var$Error
```

Next, we're going to ask the function to loop through each row of 'input_table' and identify the key values we want - the variable name, the variable type, the mean, and the error - based on the column headings used in the Excel file. **THIS IS IMPORTANT:** the column headings must match exactly for this code to work. My suggestion would be to never change them, but if you do change them in the Excel file make sure you're also changing them in the code.

```r
    if (vartype == 1){
      # Beta distributed variables
      shape1 = as.numeric(bdist(varmean, varsd)[1])
      shape2 = as.numeric(bdist(varmean, varsd)[2])
      prob_vector <- rbeta(num_iter, shape1, shape2)
    }
    
    if (vartype == 2){
      # Normally distributed variables
      shape1 = as.numeric(varmean)
      shape2 = as.numeric(varsd)
      prob_vector <- rnorm(num_iter, shape1, shape2)
    }
    
    if (vartype == 3){
      # Gamma distributed variables
      shape1 = as.numeric(gdist(varmean, varsd)[1])
      shape2 = as.numeric(gdist(varmean, varsd)[2])
      prob_vector <- rgamma(num_iter, shape1, scale = shape2)
    }
    
    if (vartype == 4){
      # Utilities
      shape1 = as.numeric(gdist(1-varmean, varsd)[1])
      shape2 = as.numeric(gdist(1-varmean, varsd)[2])
      prob_vector <- (1 - rgamma(num_iter, shape1, scale = shape2))
    }
    
    if (vartype == 5){
      # Rate Ratios - not log-transformed
      shape1 = as.numeric(log(varmean))
      shape2 = as.numeric(varsd)
      prob_vector <- exp(rnorm(num_iter, shape1, shape2))
    }
    
    if (vartype == 9){
      # Fixed values - these do not vary
      shape1 = as.numeric(varmean)
      prob_vector <- rep(shape1, num_iter)
    }
```

For each model loop, we're telling the function to check what type of variable it is and then calculate the shape/scale values accordingly. 

Variable type '5' assumes that you're using an untransformed estimate of the RR (i.e., not using the log-RR), but that you *are* using the log transformation of the standard error. In this arbitrary example, we are considering a treatment-related RR of 0.85 with a 95% CI of 0.77 - 0.94. These values are normally distributed around the *natural log* of the mean (-0.163 +/- 1.96*0.05), and then back-transformed to an RR value. If you're getting this estimate from the literature, you will probably have to derive the SE around the log(RR) yourself, based on the published 95% CI.

Variable type '9' just returns the mean value and doesn't do anything else. It's useful for values like the discount rates (as you see here) but also for any value you don't expect to vary between model runs (e.g., fee-for-service costs, the relative proportion of M/F sex in the population, number of tunnels in a health state, etc.).

```r
    # Populate the tables
    param_table_names[[i]] <- varname
    param_table_deterministic[[i]] <- varmean
    param_table_probabilistic[[i]] <- prob_vector
    
    # Add the column to the dataframe
    df_param <- data.frame(prob_vector)
    colnames(df_param) <- varname
    param_dataframe <- cbind(param_dataframe, df_param)
    
  } # end loop
```

Once we've sampled the vector of values ('prob_vector') then we append the corresponding information into the blank lists we created at the beginning of the loop. We also append a new column to our dataframe. That new column has a name that corresponds to the 'InputName' from the Excel file[^5].

[^5]: This distinction matters if you are going to use dampack to do EVPPI. I am not going to spend any time explaining what EVPPI is, I'm merely going to note that if you want to calculate it with dampack you are going to have to use the EXCEL-BASED names, not whatever you end up calling the parameter within the model itself.

```r
  # Remove temporary variable
  param_dataframe = subset(param_dataframe, select = -c(temp))
  
  # Create the output object
  outlist <- list("varname" = param_table_names,
                  "varmean" = param_table_deterministic,
                  "varprob" = param_table_probabilistic,
                  "df_psa_input" = param_dataframe) 
  
  # Pass the object into the global environment
  return(outlist) 
}
```

Finally, once the loop has completed and the values have been drawn for every row in the Inputs table, we're going to do a quick cleanup step where we remove the 'temp' column from our dataframe (I told you we would!) and then create our final object 'outlist'. This object contains the input names, means, and probabilistically sampled values, as well as our PSA dataframe for 'dampack'. The 'return' argument passes that object into the global environment so you can call it whenever you need it.

## Let's see it in action

~~~
# Run the ImportVars function from the batch importer and our Excel table
> library(readxl)
> Inputs <- read_excel("Model Inputs.xls") #The Excel file name
> Inputs <- subset(Inputs, Value >-1) #Remove blank rows
> varlist <- ImportVars(Inputs, num_iter = 10)
> varlist$df_psa_input
~~~

![The output of the dataframe][dfoutput]

[dfoutput]: https://www.dropbox.com/s/v9km62p4qiapxfu/dfoutput.jpg?dl=1

So what we're looking at is what happens when we run the ImportVars for a small value of 'num_iter' (in this case 10 was chosen arbitrarily)[^7], and then look at the 'df_psa_input'. You'll see that each column is named based on the InputName in the Inputs object, and contains 'num_iter' probabilistically-sampled values based on their respective mean and error, according to the variable type. You will also notice that the columns corresponding to our type '9' inputs are repetitions of their mean value, and do not vary. If you run it yourself you'll see that the 'varlist' object also contains the other lists with names, mean values for deterministic analysis, and probabilistically-sampled values.

[^7]: Sharp eyes will have noticed that I included 'PSA_num' as an input. I do it this way because if you want your model user (again, usually you) to be able to run the model *entirely independently* of having to interact with the code, you'll want them to be able to specify this number in Excel. The way to code the model in that case would be to do: `ImportVars(Inputs, num_iter = as.numeric(Inputs[X,Y]))`, where X and Y are the row and column number that the mean value of PSA_num is stored in (15 and 4 in this case).

Incidentally, if you wanted to pass your variables to the global environment you can do that simply:

```r
### PASS VARIABLES INTO THE GLOBAL ENVIRONMENT
  # Deterministically (just means)
  for (i in 1:length(varlist$varname)){
    assign(paste(varlist$varname[i]), unlist(varlist$varmean[i]))
  }

	# OR
  
  # Probabilistically
  for (i in 1:length(varlist$varname)){
    assign(paste(varlist$varname[i]), unlist(varlist$varprob[i]))
  }
```

These will pass each variable, by name, into the global environment so you can use them without having to make reference to 'varlist'.

## Wrapping up

In my experience, the batch importer is a relatively simple but really useful tool. It means you can have an input table of any size you want, and make changes to parameter values quickly and easily without having to monkey with the code. There are steps beyond this when it comes to actually *using* these values once they're in the global environment, but there is an example of one way to do this in the R Guide. Any future posts that contain models will almost certainly include this tool.

I may (especially if prompted) periodically update the R file to include new distributions. If you add new ones yourself, please let me know so I can add them too.

**A quick note about 'dampack' and 'bcea'**: I also favour the use of ['bcea'](https://cran.r-project.org/web/packages/BCEA/index.html), developed by Gianluca Baio, Andrea Berardi, and Anna Heath. I suggest familiarizing yourself with both packages and use whichever best suits your needs. They are both reliably excellent for doing conventional CEA, but have different features and requirements.

[**Get the code**](https://github.com/HealthyUncertainty/healthyuncertainty.github.io/blob/master/Tools/BatchImporter/ImportVars.R)