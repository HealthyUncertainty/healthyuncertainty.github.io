# Chapter 5 - Cost-Effectiveness Analysis

##NOTE: There is an updated version of this model. [Get details here](https://healthyuncertainty.github.io/2021-03-27-The-WXYZ-Model/).

Let us imagine that a new method for treating people in Health State X is being introduced. You, as a health economist, are being asked to make a recommendation to the Person In Charge Of Stuff (PICOS) about whether or not this new method is cost-effective. This new treatment method means a reduction in the risk of transition into Health State Y of 5% (with a standard error of 2%)[^1], but it comes at a cost of an additional $750 per cycle (standard error of $100).

[^1]: A long footnote here. We don’t typically see risk reductions like this published in the literature. If we’re talking about clinical trials, it’s far more common to see a relative rate (RR) or hazard ratio (HR). We can’t apply a relative rate to a probability, because probabilities and rates are different concepts. The way I typically handle this issue is to convert the probability to a rate, apply the RR/HR to that value, then convert back to a transition probability. I’m not going to detail that here because it will require a long digression and explanation, but it is possible. For the purpose of this chapter it’s not worth getting bogged down in the details of where “P_riskmod” would come from. It’s just a low-effort way to illustrate some kind of incremental change.


The question we are tasked with answering is as follows: what will be the incremental cost-effectiveness of this new treatment compared to standard treatment in a hypothetical cohort of people with the health condition of interest?

We’re going to have to go back to the drawing board a little bit in order to make this happen. First, we are going to do a little “housekeeping”. We are going to have to set up two model “arms” – in the experimental arm (which I will refer to as Arm A) people are managed according to the proposed treatment method. In the comparator arm (which I will refer to as Arm B) people are managed according to the current standard of practice.

Instead of relying on the previously-calculated values from the preceding chapters, we’ll write the code from “scratch”, with a few differences that I will highlight. Unless otherwise specified, the code we’ve written up to now (especially the stuff from Chapter 7) is the same and doesn’t need to be touched.

The first major difference is that we will have to incorporate any other differences in probabilities, costs, and/or utilities that are specific to a given arm. In our hypothetical cost-effectiveness exercise, we are looking at a change in “P_XtoY” as well as “C_X” (and their associated standard errors). The model code will have to be changed to reflect this change. This is a fairly straightforward change – other models might require dramatic changes to multiple parameters and relationships between health states, but for the purpose of this illustration it’s in our interest to keep things simple:

~~~ 
84	# Define Risk Modification
85	P_riskmod <- 1 - rbeta(n, bdist(0.05, 0.02)[,1], 
86	    bdist(0.05, 0.02)[,2])
87	    }
88	
89	# Define returning transitions
90	P_Wreturn   <- 1 - P_W_X
91	A_P_Xreturn <- 1 - (P_X_W + P_X_Y*P_riskmod)
92	B_P_Xreturn <- 1 - (P_X_W + P_X_Y)
93	P_Yreturn   <- 1 - P_Y_Z
94	P_X         <- 1 - P_W
~~~

This code defines a parameter called “P_riskmod”, which serves the function of a risk multiplier – multiply the existing transition probability by the risk modifier (1.0 - ~5%), and we get the modified risk. We have to change the returning probabilities to reflect this difference, and because only person-groups in Arm A have this changed risk, we need different values for each arm (note that Arm B has not changed from our previous default code).

The second major difference is that we will need to have (at least) twice as many health states. Each arm of the study will need to have their own version of each health state – i.e., there needs to be a “HS_W” in arm A and one in arm B, and so on. Some models may have different structures and require more/fewer health states, but regardless you cannot use the same array for different arms of the model:

~~~
97	# Define blank arrays for both arms
98	    A_HS_W <- A_HS_X <- array(0, dim=c(ncycle,1,n))
99	    A_HS_Y <- A_HS_Z <- array(0, dim=c(ncycle,2,n))
100	
101	    B_HS_W <- B_HS_X <- array(0, dim=c(ncycle,1,n))
102	    B_HS_Y <- B_HS_Z <- array(0, dim=c(ncycle,2,n))
103	
104	# Define starting population in each state
105	for (j in 1:n){
106	    A_HS_W[1,1,j] <- B_HS_W[1,1,j] <- npop*P_W[j]
107	    A_HS_X[1,1,j] <- B_HS_X[1,1,j] <- npop*P_X[j]}
~~~
Note that the arrays, in this case, are the same size across the two arms. We could have done this in fewer lines of code, but I figured it was easier to see the changes if done this way.

Now that we’ve made the modifications, we set up our health state transitions for the two different arms:
~~~ 
109	### DESCRIBE TRANSITIONS BETWEEN HEALTH STATES
110	# Experimental Arm
111	  for (j in 1:n){
112	  for (i in 2:ncycle){
113	    A_HS_W[i,,j] <- A_HS_W[(i-1),,j]*P_Wreturn[j] + 
             A_HS_X[(i-1),,j]*P_X_W[j]
114	         
115	    A_HS_X[i,,j] <- A_HS_X[(i-1),,j]*A_P_Xreturn[j] + 
             A_HS_W[(i-1),,j]*P_W_X[j]
116	     
117	    A_HS_Y[i,1,j] <- A_HS_X[(i-1),,j]*P_X_Y[j]*P_riskmod[j]
118	    A_HS_Y[i,2,j] <- sum(A_HS_Y[(i-1),,j])*P_Yreturn[j]
119	     
120	    A_HS_Z[i,1,j] <- sum(A_HS_Y[(i-1),,j])*P_Y_Z[j]
121	    A_HS_Z[i,2,j] <- sum(A_HS_Z[(i-1),,j])
122	    }}
123	
124	# Control Arm
125	  for (j in 1:n){
126	  for (i in 2:ncycle){
127	    B_HS_W[i,,j] <- B_HS_W[(i-1),,j]*P_Wreturn[j] + 
            B_HS_X[(i-1),,j]*P_X_W[j]
128	  
129	    B_HS_X[i,,j] <- B_HS_X[(i-1),,j]*B_P_Xreturn[j] + 
            B_HS_W[(i-1),,j]*P_W_X[j]
130	   
131	    B_HS_Y[i,1,j] <- B_HS_X[(i-1),,j]*P_X_Y[j]
132	    B_HS_Y[i,2,j] <- sum(B_HS_Y[(i-1),,j])*P_Yreturn[j]
133	   
134	    B_HS_Z[i,1,j] <- sum(B_HS_Y[(i-1),,j])*P_Y_Z[j]
135	    B_HS_Z[i,2,j] <- sum(B_HS_Z[(i-1),,j])
~~~
We add in our ‘risk modification’ effect in line 122 (it’s absent in the control arm on line 136). This step will now change the number of people moving between “HS_X” and “HS_Y”. Everything else remains the same as it was before[^3].

[^3]: Another long digression here: this isn’t necessarily the way I would suggest you build a model. Writing the code to make one arm, and then adapting that arm to make two – this is probably the least convenient way to do it. If you’re going to build a model, you should design all arms independently. This may mean you have to create multiple transition probabilities or costs, but believe it or not, defining the variables is usually the easiest part of the coding process. Having a coherent design and making that design hang together properly is the trickiest aspect of model coding, especially as the structure of the model becomes more complex. The reason we’re doing it this way is simply so that we’re working with familiar code. While it will usually be the case that parts of the various arms of a model will have similar or identical code, it’s not usually the case that one arm is just a slight modification from the other. Again, I’ve done it this way so it’s easier to follow the code. In reality you’d probably have the additional risk and costs as parameters in your inputs .xls file.


We have only one more modification to make before we can run this cost-effectiveness exercise, and that’s to incorporate the costs of the experimental approach into the appropriate arm. First we define the parameter as a probabilistic R object:
~~~
142	# Define additional cost paramter for experimental arm (Arm A)
143	CO_add[,,j] <- rgamma(n, gdist(750, 100)[,1], scale = 
                     gdist(750, 100)[,2])[j]}
~~~
And then we describe the costs for both arms (note the differences between Lines 169 and 179):
~~~
145	# Create blank arrays for costs
146     cost_AHSW <- cost_AHSX <- cost_BHSW <- cost_BHSX <- 
                        array(0, dim=c(ncycle,1,n))
147	    cost_AHSY <- cost_AHSZ <- cost_BHSY <- cost_BHSZ <- 
                        array(0, dim=c(ncycle,2,n))
148	
149	# Populate arrays
150	for (j in 1:n){
151	  cost_AHSW[,,j] <- A_HS_W[,,j]*C_W[j]
152	  cost_AHSX[,,j] <- A_HS_X[,,j]*(C_X[j] + C_add[j])
153	       
154	  cost_AHSY[,1,j] <- A_HS_Y[,1,j]*(C_Yt[j] + C_Y[j])
155	  cost_AHSY[,2,j] <- A_HS_Y[,2,j]*C_Y[j]
156	       
157	  cost_AHSZ[,1,j] <- A_HS_Z[,1,j]*C_Zt[j]
158	}
159	 
160	for (j in 1:n){
161	  cost_BHSW[,,j] <- B_HS_W[,,j]*C_W[j]
162	  cost_BHSX[,,j] <- B_HS_X[,,j]*C_X[j]
163	       
164	  cost_BHSY[,1,j] <- B_HS_Y[,1,j]*(C_Yt[j] + C_Y[j])
165	  cost_BHSY[,2,j] <- B_HS_Y[,2,j]*C_Y[j]
166	       
167	  cost_BHSZ[,1,j] <- B_HS_Z[,1,j]*C_Zt[j]
168	}
~~~
Since our hypothetical research question doesn’t make any change to the utilities associated with each health state, we can leave the code more or less as it was from the previous chapter – the only difference is that we have to, again, describe each model arm separately:
~~~
172	# Create blank arrays for utilities
173	Util_AHSW <- util_BHSW <- util_AHSX <- util_BHSX <- 
                   array(0, dim=c(ncycle,1,n))
174	util_AHSY <- util_BHSY <- array(0, dim=c(ncycle,2,n))
175	
176	# Populate arrays
177	for (j in 1:n){
178	    util_AHSW[i,,j] <- A_HS_W[i,,j]*U_W[j]
179	    util_AHSX[i,,j] <- A_HS_X[i,,j]*U_X[j]
180	    util_AHSY[i,,j] <- A_HS_Y[i,,j]*U_Y[j]
181	 }
182	
183	for (j in 1:n){
184	    util_BHSW[i,,j] <- B_HS_W[i,,j]*Q_W[j]
185	    util_BHSX[i,,j] <- B_HS_X[i,,j]*Q_X[j]
186	    util_BHSY[i,,j] <- B_HS_Y[i,,j]*Q_Y[j]
187  }
~~~
We can now run the model and calculate the LYG, QALYs, and costs that it outputs. Calculating these values is very straightforward to do from the arrays.
Life Years is defined as the cumulative sum of all years lived in the model. All we have to do is count up everyone who isn’t dead (i.e., not in Health State Z). QALYs are calculated in the same way. With costs, because we do have costs that accumulate as people transition into Health State Z, we have to make sure we include them:
~~~
191	# Create blank utilities for LYG, QALY, and costs from both arms
192	    LYG_A <- LYG_B <- QALY_A <- QALY_B <- COST_A <- COST_B <- 
            array(0, dim=c(ncycle,1,n))
193	
194	for (i in 1:ncycle){
195	# Calculate LYG per cycle for each arm
196	    LYG_A[i,,] <- A_HS_W[i,,] + A_HS_X[i,,] + colSums(A_HS_Y[i,,])
197	    LYG_B[i,,] <- B_HS_W[i,,] + B_HS_X[i,,] + colSums(B_HS_Y[i,,])
198	
199	# Calculate QALY per cycle for each arm
200	    QALY_A[i,,] <- util_AHSW[i,,] + util_AHSX[i,,] + 
                    colSums(util_AHSY[i,,])
201	    QALY_B[i,,] <- util_BHSW[i,,] + util_BHSX[i,,] + 
                    colSums(util_BHSY[i,,])
202	
203	# Calculate costs per cycle for each arm
204     COST_A[i,,] <- cost_AHSW[i,,] + cost_AHSX[i,,] + 
                    colSums(util_AHSY[i,,]) + colSums(cost_AHSZ[i,,])
205     COST_B[i,,] <- cost_BHSW[i,,] + cost_BHSX[i,,] + 
                    colSums(util_BHSY[i,,]) + colSums(cost_BHSZ[i,,])
206	}
~~~
Here’s a sample of what “LYG_A” looks like:
~~~
LYG_A[,,1]

      [,1]
 [1,] 1000.000000
 [2,] 1000.000000
 [3,]  962.004527
 [4,]  902.863267
 [5,]  833.804653
 [6,]  761.826360
 [7,]  691.062344
 [8,]  623.806779
 [9,]  561.209706
[10,]  503.728353
[11,]  451.412557
[12,]  404.082241
[13,]  361.436232
[14,]  323.117973
[15,]  288.754425
[16,]  257.978409
[17,]  230.440820
[18,]  205.816695
[19,]  183.807621
[20,]  164.142000
        . . .
~~~
Not terribly exciting, but the important thing to take away from this is that all of the people who are alive in the model at each cycle are listed in the array. The reason why this is important is for the next step: discounting.

Discounting is accomplished by applying the following formula:

![alt text][Disc_Eqn]

[Disc_Eqn]: https://www.dropbox.com/s/93v7ca3j54d84jj/5%20Discount%20Equation.jpg?dl=1 "Equation for Future Time Preference"
 
Where *t* is time (in years), *n* is the integer value of a given year, and *r* is the discount rate used in the analysis. We have defined *r* – the discount rate for costs and outcomes (“Disc_C” and “Disc_O”, respectively) – all the way back on line 34-35.

In order to apply discounting, we have to define the length of time each cycle represents. For the sake of simplicity, we’re going to define the cycle length of this model as one year. That means that things happening in cycle 2 happen one year later than since in cycle 1, and so on. We must apply the discounting rate at each year – which in this case means each cycle. We can do that quite simply:

~~~
210	# Create an array for years of time passed
211	year <- array(dim=c(ncycle,1,n))
212	for (i in 1:ncycle){year[i,,] <- (i-1)}
~~~
 
This creates an array that contains the following:
~~~
, , 1

      [,1]
 [1,]    0
 [2,]    1
 [3,]    2
 [4,]    3
 [5,]    4
 [6,]    5
 [7,]    6
 [8,]    7
 [9,]    8
[10,]    9
[11,]   10
[12,]   11
[13,]   12
[14,]   13
[15,]   14
[16,]   15
[17,]   16
[18,]   17
[19,]   18
[20,]   19
…
~~~

You may be asking yourself why the year numbers lag behind the cycle numbers (i.e., why it’s a list from 0-49 rather than 1-50). Consider the following: how much time has passed in cycle 1? It’s the beginning of the time horizon, at which point no transitions of any kind have occurred. By definition, no time has passed in cycle 1. It makes no sense, therefore, to discount outcomes or costs in that year.

Now consider this: how much time has passed in cycle 2? Since the interval between any consecutive cycles is one year (by definition), one year has passed. Applying a year of discounting is appropriate. Carry this pattern through to the end of the model, and you see the reason why the “year” array is structured this way.

Now that we have the “year” counter in place, we can apply discounting quickly and easily:
~~~
214	# Apply outcome discounting
215	    DLYG_A <- LYG_A*(1/(1+Disc_O)^(year))
216	    DLYG_B <- LYG_B*(1/(1+Disc_O)^(year))
217	
218	    DQALY_A <- QALY_A*(1/(1+Disc_O)^(year))
219	    DQALY_B <- QALY_B*(1/(1+Disc_O)^(year))
220	
221	# Apply cost discounting
222	    DCOST_A <- COST_A*(1/(1+Disc_C)^(year))
223	    DCOST_B <- COST_B*(1/(1+Disc_C)^(year))
~~~
 
I’ll give you the first few lines of the “DLYG_A” array so you can see the result of the code:
~~~
DLYG_A[,,1]

             [,1]
 [1,] 1000.000000
 [2,]  985.221675
 [3,]  946.519605
 [4,]  880.492749
 [5,]  800.781339
 [6,]  717.939090
 [7,]  637.981079
 [8,]  563.823003
 [9,]  496.588650
[10,]  436.443351
[11,]  383.073524
[12,]  335.950331
[13,]  294.470201
[14,]  258.027092
[15,]  226.047566
[16,]  198.005909
[17,]  173.428762
[18,]  151.894437
[19,]  133.029707
[20,]  116.505549
        . . .
~~~
We have now successfully discounted our observed values for LYG, QALYs, and costs to reflect their present value at a rate of 1.5%.

Our next step is the relatively straightforward one of calculating ΔC and ΔE. We have to first calculate the sum of all LYG, QALYs, and costs in each arm, and then subtract them from each other. Because we have used a sample population of size “npop” (in this case, 1000 people per person-group), and because it makes the most sense to express ΔC and ΔE at the level of an individual person, we’re going divide the difference by “npop”. Our goal is to produce a list of “n” values for ΔC and ΔE – one for each slice in the model:

~~~
227	DeltaC <- DeltaE <- DeltaQ <- matrix(0, nrow=n, ncol=1)
228	for (j in 1:n){
229	  DeltaC[j,] <- (sum(DCOST_A[,,j]) - sum(DCOST_B[,,j]))/npop
230	  DeltaE[j,] <- (sum(DLYG_A[,,j]) - sum(DLYG_B[,,j]))/npop
231	  DeltaQ[j,] <- (sum(DQALY_A[,,j]) - sum(DQALY_B[,,j]))/npop }
~~~
 
The output is three lists of 10,000 numbers. Not exactly the most scintillating reading in the world, so I’m going to skip it. Instead, I’ll show you some summary statistics that will allow you to get a good picture of each:
![alt text][CEA_Summary1]

[CEA_Summary1]: https://www.dropbox.com/s/80ptxxfx82ks47b/5%20CEA%20Output%20Distributions.jpg?dl=1 "Summary and Histograms of LYG, Costs, and QALYs"
 	
The output tells us that the intervention modeled in Arm A provides (on average) 0.32 additional LYG, while increasing costs (on average) by about $5,003. These values are distributed in a way that reflects the uncertainty in the various parameters that go into determining the final values.

We can calculate our ICERs quite easily from here:
~~~
233	## Calculate ICER
234	    ICER <- DeltaC/DeltaE
235	    QICER <- DeltaC/DeltaQ
~~~

And the output is:
~~~
>ICER
[1] 15869.14

>QICER
[1] 18246.11
~~~
 
The intervention we’re analyzing has a mean ICER of $15,869/LYG, or $18,246/QALY.
That’s more or less the whole ball of wax right there. We created our two comparator scenarios, derived probabilistic estimates for each model parameter, simulated survival and costs in each arm, derived the present value through discounting, calculated incremental costs and outcomes, and calculated ICERs accordingly. All in around 250 lines of code (including annotations). Not bad!

Of course we’re not quite done – while we know the mean ICER values, we haven’t really looked at the effect that the uncertainty of our parameters has on the recommendation we’d give the PICOS. In other words, we haven’t done our PSA yet. Luckily, the work we’ve done up to now makes PSA a breeze from here.

Well… the work we’ve done, and the work done by [Gianluca Baio, Anna Heath, and Andrea Berardi](http://www.statistica.it/gianluca/software/bcea/), creators of the fantastic ‘BCEA’ package. Thanks to their diligent effort, you can create plots of the cost-effectiveness plane and cost-effectiveness acceptability curves (CEACs) nearly effortlessly.

One thing we’ll have to do is put our model output into a form that the package understands. That means we will need the following:

-	The BCEA package installed – this should already be done if you’re using the sample code, but if you’re building your own model from scratch you’re going to have to install it (see Chapter 7 if you need a refresher).
-	An ‘N by 2’ matrix to hold total (discounted) costs from each arm of the model
-	A similar matrix to hold total (discounted) outcomes from each arm of the model

Creating the matrices is straightforward:
~~~
260	## Create blank matrices for effectiveness, cost
261	BCEA_DC <- BCEA_DE <- BCEA_DQ <- matrix(nrow = n, ncol=2)
262	
263	## Populate matrices
264	for (j in 1:n){
265	BCEA_DC[j,1] <- sum(DCOST_A[,,j])/npop
266	BCEA_DC[j,2] <- sum(DCOST_B[,,j])/npop
267	
268	BCEA_DE[j,1] <- sum(DLYG_A[,,j])/npop
269	BCEA_DE[j,2] <- sum(DLYG_B[,,j])/npop
270	
271	BCEA_DQ[j,1] <- sum(DQALY_A[,,j])/npop
272	BCEA_DQ[j,2] <- sum(DQALY_B[,,j])/npop}
~~~
 
And now we can run the ‘BCEA’ analysis:
~~~
bcea(e=BCEA_DE, c=BCEA_DC, interventions = c("A", "B"), Kmax=100000)
~~~
Let’s walk through this code:
-	**bcea(** - perform the ‘bcea’ function
-	**e=BCEA_DE** – the ‘N by 2’ matrix of effectiveness is contained in the object “BCEA_DE”
-	**c=BCEA_DC** – the ‘N by 2’ matrix of costs is contained in the object “BCEA_DE”
-	**interventions** = c("A", "B") –  label the two arms of the analysis “A” and “B”
-	**Kmax=200000** – the X axis for the Value of Information and CEAC graphs extends to a maximum willingness-to-pay value of $100,000.

Once we run it, we can use the commend plot.bcea, which produces this:

![alt text][BCEA_Out]

[BCEA_Out]: https://www.dropbox.com/s/uogtzmdvc8vgapx/5%20BCEA%20Figures.jpg?dl=1 "The output of a BCEA plot"

In the top left is our cost-effectiveness plane graph, showing the ‘N’ ICERs produced by the model, as well as an estimate of the median value. A line showing $25,000/LYG (or QALY) is plotted automatically. A CEAC is shown in the bottom left, going from zero to “Kmax”. EIB and EVI summaries are in the right column – I’m not going to spend much time attempting to explain these in this guide, but they are both useful and important for providing context to the decision-making process.

There are more functions in the BCEA package that you can dig into, but I will leave that up to you. The last thing I want to show you before we head into the concluding chapters is how to find the “answer” to the question “how cost-effective is this new technology?” Put plainly, what percentage of ICERs are below a given WTP value? We can do this with BCEA’s summary function:

~~~
>BCEA.LYG <- bcea(e=BCEA_DE, c=BCEA_DC, interventions = 
                c("A", "B"), Kmax=100000)

> summary(BCEA.LYG, wtp = 50000)

Cost-effectiveness analysis summary 

Reference intervention:  A
Comparator intervention: B

Optimal decision: choose B for k<16000 and A for k>=16000


Analysis for willingness to pay parameter k = 50000

  Expected utility
A           526101
B           515340

         EIB  CEAC  ICER
A vs B 10761 0.987 15869

Optimal intervention (max expected utility) for k=50000: A

~~~

The Output suggests that at a WTP value of $50,000/LYG, A has a 98.7% probability of being considered cost-effective compared to B. You can use whatever WTP value is most appropriate for your decision-making context.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter6)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter4_6)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)