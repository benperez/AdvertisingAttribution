AdvertisingAttribution
======================

A machine learning project to fit consumer's web-browsing and advertising impression data to a ***TOP-SECRET*** Hidden Markov/Bayesian Model to evaluate the effectiveness of several different types of advertisements in an online ad campaign.

This project implements an advertising attribution model developed by two Statistics/Marketing professors at Wharton. The first part of the project generates a representative dataset of consumer behavior on the internet according to a tunable statistical model. The second portion of the project uses Matlab to try and fit the parameters of that same model to a generated dataset. The end goal of the project is to demonstrate technical proficiency in implementing both sides of a model-generating/model-fitting scenario by showing that given enough data and time, the model-fitting portion of the project should be able to completely recover the parameters that were input to the model-generating portion of the project.

=====================

The Problem: Attribution of credit to internet search and display ads is a hard problem. Current methods use overly simplistic, last-touch attribution, giving all credit to the ad the consumer actually clicked on and ignoring all previous ads that may have had an effect on consumers.

=====================

The Data: The dataset for this problem is complete record of a consumer's interaction with a particular brand online. This includes data on the number of generic display ad impressions for a brand that were seen and when they were seen, the number of search ad impressions that were seen and when they were seen, the number of specific display ad impressions that were seen and when they were seen, the number of pageviews the consumer had of the brand's website, and also data and whether and at what time the consumer underwent a "conversion" activity, basically purchasing the product.

Obviously this data is only available to very specific parties inside an ad agency or brand, so I wrote a Python script which uses numpy/scipy.stats to simulate the behavior of many consumers over a long time period to produce a representative dataset of their online behavior.

The code to generate the dataset can be found in data_generation/generating.py

=====================

The Model: This project was at one point considered pretty sensitive/private so I'd rather avoid getting too in-depth into the specifics of this model in case anyone at Wharton/elsewhere is still pursuing. 

From a high-level, the model tries to simulate the movement of an online consumer down the well-known "conversion funnel" as they interact with different ads. The four stages of the funnel correspond to four distinct states in a Hidden Markov Model. What's interesting about this HMM is that its transition probabilities are based on a logistic function of the number and type of ads encountered by a consumer and its emission probabilities are based on a Poisson process and a Binomial model for pageviews and conversion that are also affected by which ads were seen.

The basic idea is that the parameters fit for this model can tell advertisers a ton about how effective different types of ads are at moving customers down the conversion funnel and also at influencing a later decision to purchase. They tell a much richer story than just "This customer clicked on this ad last, so it must have worked..."

=====================

The Challenge (Fitting the model): This was definitely the most challenging portion of this project. The main reason fitting a model like this was so hard is because it involves so many different parameters, about 65 in total. Although it is a Hidden Markov Model, it can't be fit using traditional HMM techniques, mainly because the parametes for the model vary over time, (in HMM speak, it contains "time-varying covariates"). 

Given the complexity of the model and how much it diverges from almost any model in the literature I found, I decided that I had to build my own custom set of Matlab scripts to fit the parameters by optimizing the model's likelihood function, specifically the log-likelihood.

With 63 independent parameters, though, I immediately knew that the search space for the optimal parameters was going to be absolutely enormous. Additionally, I didn't have any expensive Matlab solvers at my disposal so I was going to have to be clever in how I did the optimization on my own. I decided to use Newton-Raphson to perform the optimization using the gradient and hessian of the log-likelihood function. 

After some hard work, this proved to lead nowhere, since there wasn't a simple closed-form way to write the gradient and hessian of the log-likelihood function. The main problem was the the "log" trick of the log-likelihood function did not turn my products of different time-steps into sums, since the product of time-steps was actually a complicated matrix multiplication of logistic functions. Without being able to sum small, simple gradient and hessian components over time-steps, I wasn't going to be able to do an easy Newtown-Raphson technique in Matlab. What I ended up doing was settling for something very simplistic to get some results out. I used a min-search function that I had found online. This gave me some fine preliminary results, but I knew it wasn't going to be anywhere near optimal.

The code for this traditional optimization approach can be found in model_fitting/traditional_optimization.

After I had some preliminary results, I decided to try and be smart by letting Matlab do all of the difficult gradient/hessian computations. It also gave me a chance to play with Matlab's symbolic toolkit, which I have to say is pretty incredible. I wrote symbolic functions for the entire model, and tried to feed them into Matlab's built in gradient and Hessian finders. This would give me functions in Matlab that I could drop into a Newtown-Raphson method to do the optimization nicely. Unfortunately, I think the model was too complicated for the symbolic toolkit and it never finished running, even after about a day of non-stop work on an 8-core machine.

That's basically where I left off, since I started looking for nicer ways to do the optimization without needing gradients and hessians.

Long story short, I got OK preliminary results, but real optimization proved to be a lot more difficult.