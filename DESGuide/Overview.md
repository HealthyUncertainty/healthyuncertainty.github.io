---

---

I want to give a quick overview of next-event modelling, as a way of introducing some of the specific things I'm going to be doing in Python. This post won't give you much of a background in model theory, but hopefully it will be a straightforward aid.

## A high-level summary of next-event models

Next-event models (generally referred to as 'Discrete Event Simulation' or DES[1]) are a form of agent-based microsimulation. Individual entities (simulated people) will be assigned characteristics that will influence their path through the model. Based on those characteristics and the structure of the model, they will be scheduled to experience some event at a randomly sampled time. The simulation clock moves ahead to the time the event is scheduled to occur, and the entity experiences the event. The entity carries a record of each event it experiences and any related resources used, and health utility they experience as a result of that event. The entity's characteristics may change as a result of the event. The entity is then scheduled to experience the next event, based once again on their characteristics and the model's structure. The entity's path through the model ends either at the model's time horizon or when the entity experiences a terminal event (death, usually).

![1]: There is a more complex and specific set of nomenclature that differentiates different types of models. DES is a broad category that includes a bunch of specific kinds with specific features. I am going to choose to use 'DES' because that's the name most people know them by, even when they are talking about models that are not technically DES. I apologize to the sticklers. You can yell your excellent points at me in the comments.

Like Markov models, DES models consider the passage of time. Unlike Markov models, time does not occur at fixed intervals (i.e., the cycle length of a Markov model). Instead, events occur in "simulated real time" - that is, they occur at continuous intervals that are meant to represent the actual time that would occur between events. For example, in a Markov model with a six-month cycle length, events can occur every six months but they can't occur at five months or at a week. In a DES model, if it takes four weeks, three days, twenty hours and four minutes for something to happen then that's when it happens. Of course, just like Markov models don't actually take years to run, each event in a DES model occurs at the speed of a computer calculation. The feature of a DES that tracks those times is referred to as 'the clock'. The clock is a running tally of the amount of simulated time that has occurred, and advances to the appointed time for each sequential event.

We can use the DES simulate a cohort of entities and run them through the model under a given set of conditions. Then we can run them through a *different* set of conditions - conditions resembling some kind of policy change. We can then count up the cost of all resources used and the quality-adjusted survival experienced by each entity under the different conditions, and use that information to estimate incremental costs and QALYs for the cohort.

## My approach to building DES

There are four general steps that I use in my approach to DES:

### Step 1: Load packages and model inputs

As with my approach to R-based models, values are pulled in from an Excel spreadsheet. This allows users to change model parameter values without having to muck around inside the code. The first part of the program involves pulling the data into the global environment as a Python dictionary where it can be read by the model whenever it's needed. There are also going to be some Python packages we're going to want to install and run to do some our key statistical functions, among other things.

### Step 2: Create a new entity

An entity (a simulated person) takes the form of a Python dictionary that can add and modify its contents. This feature means you can apply a fully customizable set of characteristics to an entity at any point within the model, or modify an existing characteristic. The contents of the entity's library can therefore be used to carry any kind of information you want: survival, resource use, demographic variables, event history, utility... you name it.

### Step 3: Simulate entity's path through the model

Once the entity has been assigned its starting characteristics, it can be sent into the model environment. I refer to this part of the model as the Sequencer - a function that determines the sequence of events based on the entity's current position. The sequencer operates as a loop, continuously directing the entity to its next event until it reaches a terminal point. At that point, the entity's journey is done and we can store it to analyze later. The Sequencer is likely going to be the most complicated part of the model design.

### Step 4: Analyze results

Once we have a population of entities simulated, we can analyze each one to calculate the results we want. That will include the conversion of resources to costs, the conversion of survival times to LYG, and the calculation of QALYs. If there are other outcomes we are interested in, we can estimate them here.

There is a lot of complexity that I've stripped out of this description, but these are the basic steps. As I say above, the Sequencer is the trickiest one but we'll get to that in a bit.

## Designing a DES

The most complicated part of the modelling process isn't the code, it's the design. Unlike a typical Markov model, DES models don't move in the same way between states at a specific rate. Instead, they move between different events based on their current position. What that means practically is that DES models are better understood through path diagrams than through the typical "bubble and arrow" diagram you might be used to seeing for a Markov. I am going to use a diagram convention that I took from [a textbook on DES for Health Technology Assessment](https://www.taylorfrancis.com/books/discrete-event-simulation-health-technology-assessment-jaime-caro-j%C3%B6rgen-m%C3%B6ller-jonathan-karnon-james-stahl-jack-ishak/10.1201/b19421):

[Path Diagram Key

- Origin Node: This is where all entities within the model begin
- Entity Paths: These describe how entities may move between different elements. Dotted-line paths describe movement that happens across model components.
- Decision Nodes: A process where one of multiple potential paths are possible for a given entity. The code samples an underlying probability of each path occurring, and compares that sampled value to a randomly-generated value from a uniform distribution to determine which one occurs.
- Characteristic Nodes: A point at which an entity is assigned a new characteristic – a treatment flag (e.g., surgery/drugs/behaviour change), a demographic value (e.g., age, M/F, Ever/Never Smoker, etc.), or other information that governs its movement through subsequent parts of the model.
- Resource Nodes: Similar to characteristic nodes, these are points at which entity resource utilization is applied (e.g., a medical appointment, a treatment, a health service, etc.).
- Temporal Nodes: Describes the passage of time between model events. An entity ‘waits’ for a number of days before moving to the next node.
- Destination Nodes: These describe an entity moving across different model components. They correspond to the dotted-line entity paths.
- Terminal Nodes: A point at which an entity’s route through the model ends. Within the WDMOC, the terminal nodes signify death either from oral cancer or from another cause.

This will probably all seem pretty abstract until we actually get started with the model-building process, but let's take a look at the four-state Markov model that we explored in the R Guide:

[Markov Diagram


