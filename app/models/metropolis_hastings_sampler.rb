require 'simple-random'

class MetropolisHastingsSampler
  
  def q(x)
    SimpleRandom.new.normal(x, 1)
  end
  
  def p(x)
    if x>0 and x<1
      1
    else
      0.000000001
    end
  end
  
  def sample(x0=0.5,n=50,burn=150)
    r = SimpleRandom.new
    x = []
    xLast = x0
    pLast = self.p(x0)
    while x.length < burn + n
      xPrime = q(x.last)
      pPrime = self.p(x)
      if pPrime/pLast < r.Uniform
        xLast = xPrime
        pLast = pPrime
        x << xLast
      end
    end
    
  end
  
end