import scipy.stats as ss

def plot_beta(x_range, a, b, plt, mu=0, sigma=1, cdf=False, **kwargs):
  '''
  Plots the f distribution function for a given x range, a and b
  If mu and sigma are not provided, standard beta is plotted
  If cdf=True cumulative distribution is plotted
  Passes any keyword arguments to matplotlib plot function
  '''
  x = x_range
  if cdf:
    y = ss.beta.cdf(x, a, b, mu, sigma)
  else:
    y = ss.beta.pdf(x, a, b, mu, sigma)
  plt.plot(x, y, **kwargs)

