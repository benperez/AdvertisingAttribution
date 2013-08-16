from __future__ import division
import numpy as np
import scipy.io

class Consumer:

	#Constructor, Use input dictoinary of fields
	def __init__(self, **kwargs):
		vars(self).update(kwargs)
		self.converted = False

	def update_events(self):
		#Get random values, use Poisson distribution for ad events
		self.ad_events += [np.random.poisson(lam,1)[0] for lam in self.ad_means]

	#Simlate the consumer transitioning to a different state during this time step
	def update_transitions(self):
		e = lambda s: 0.0 if s == self.state else np.exp(self.beta_nots[self.state-1, s-1] + np.dot(self.ad_events, self.betas[self.state-1, s-1]))
		e_ss = [e(d) for d in range(1,4)]
		q_ss = [1./(1.+sum(e_ss)) if ss==0. else ss/(1.+sum(e_ss)) for ss in e_ss]
		self.state = np.random.multinomial(1,q_ss).argmax() + 1

	#Simulate the consumer converting at the current time step
	def convert(self):
		#Only convert in states 2 and 3
		if self.state == 2 or self.state == 3:
			zeta = np.append(self.ad_events, sum(self.page_views) )
			term = self.alphas[self.state-1] + np.dot(self.gammas[self.state-1],zeta)
			p_conversion = np.exp(term) / (1. + np.exp(term))
			return np.random.rand() < p_conversion
		return False

	#Simulate the number of pages the consumer viewed at the current time step
	def view_pages(self):
		#Only view pages in states 2 and 3
		if self.state == 2 or self.state == 3:
			l = self.nus[self.state-1] + np.dot(self.taus[self.state-1],self.ad_events)
			self.page_views.append(np.random.poisson(l))
		else:
			self.page_views.append(0)

#Main method of the program, running this will prompt the user
#for a numer of consumers and timesteps to simulate, then will
#save the results of the simulation into a matlab file in the
#directory where the program is run named attribution.mat
#Example usage:
# >>> python generating.py
# Number of Consumers: 2000
# Number of Time Steps: 20
if __name__ == "__main__":
	#Simulation-wide parameters
	n_consumers = int(raw_input("Number of Consumers: "))
	time_steps = int(raw_input("Number of Time Steps: "))

	#For recording observations
	xprime_it = []
	n_it = []
	c_it = []

	#Init all consumers, use parameter values estimated in the paper
	consumers = []
	for i in range(0,n_consumers):
		xprime_it.append([])
		n_it.append([])
		c_it.append([])
		#Set parameters
		ad_means = np.array([13.756,4.211,0.072,0.143,0.246]) / time_steps
		b_12,b_13 = [0.009,0.014,0.126,0.189,0.550],[0.003,0.002,0.020,0.003,0.031]
		b_21,b_23 = [0.102,0.008,-0.098,0.077,-0.029],[0.002,0.003,0.383,0.501,0.413]
		b_31,b_32 = [0.009,-0.001,-0.001,0.021,0.048],[0.003,0.003,-0.079,0.000,-0.002]
		b_e = [0]*len(b_12)
		beta_nots = np.array([ [0.,-2.864,-5.632], [-3.713,0.,-2.206], [-3.405,-4.327,0.] ])
		betas = np.array( [ [b_e,b_12,b_13], [b_21,b_e,b_23], [b_31,b_32,b_e] ])
		t_1,t_2,t_3 = [0]*5,[0.004,0.004,0.089,0.132,0.169],[0.008,0.005,0.123,0.207,0.288]
		taus = np.array([t_1,t_2,t_3])
		nus = np.array([0,0.781,2.487])
		g_1,g_2,g_3 = [0]*6,[0.015,0.017,0.289,0.607,0.146,0.091],[0.008,0.020,0.318,0.303,0.588,0.067]
		gammas = np.array([g_1,g_2,g_3])
		alphas = np.array([0,-4.155,-3.072])
		ad_events = np.zeros(len(ad_means))
		page_views = []
		kwargs = {"state":1,"ad_means":ad_means,"beta_nots":beta_nots,"betas":betas,"taus":taus,"nus":nus,"gammas":gammas,"alphas":alphas,"ad_events":ad_events,"page_views":page_views}
		consumers.append( Consumer(**kwargs) )

	#Simulate behavior
	all_consumers = consumers
	t_length = []
	for t in range(0,time_steps):
		c_ind = 0
		for c in consumers:
			if c.converted == True:
				c_ind += 1
				continue
			#Process Ad Events
			c.update_events()
			xprime_it[c_ind].append(c.ad_events.tolist())
			#Process Page Views
			c.view_pages()
			#Process Conversions
			if not c.convert():
				#Process State Transitions
				c.update_transitions()
				c_it[c_ind].append(0)
			else:
				t_length.append(t)
				c_it[c_ind].append(1)
				c.converted = True
			c_ind += 1
		#print ""

	mean_obvs = np.zeros(5)
	c_ind = 0
	for c in consumers:
		n_it[c_ind].extend(c.page_views)
		mean_obvs += c.ad_events
		t_length.append(time_steps)
		c_ind += 1
	
	#Pad the ends of the arrays to make matlab happy
	for xp in xprime_it:
		if len(xp) < time_steps:
			[xp.append([0]*len(xp[0])) for i in range(0,time_steps-len(xp))]
	for ni in n_it:
		if len(ni) < time_steps:
			[ni.append(0) for i in range(0,time_steps-len(ni))]
	for ci in c_it:
		if len(ci) < time_steps:
			[ci.append(0) for i in range(0,time_steps-len(ci))]

	print_output = False
	if print_output:
		print "%f%% of Consumers Converted" % ((n_consumers - len(consumers))*100/n_consumers )
		print "Ad Event Summary Statistics: " + str(mean_obvs / n_consumers)
		print "Average Consumer Lifespan: %f" % (np.mean(t_length))
		print "Average Number of Pages Viewed: %f" % (np.mean([sum(k.page_views) for k in all_consumers]))
		print "open"
		for u in xprime_it:
			print u
		print "close"
		print ""
		print "open"
		for s in n_it:
			print s
		print "close"
		print ""
		print "open"
		for t in c_it:
			print t
		print "close"

	#Save results of run out to a matlab file
	#Everything needs to be in numpy matrix format
	xpit = np.array(xprime_it)
	nit = np.array(n_it)
	cit = np.array(c_it)
	scipy.io.savemat('attribution.mat', mdict={'xprime':xpit,'nit':nit,'cit':cit})


