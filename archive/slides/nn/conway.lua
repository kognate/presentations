require 'nn'

timer = torch.Timer() 

coinToss = function()
   	 if math.random(10) < 5 then
	    return 1
	 else
	    return 0
	 end
end

randomMatrix = function(r,c)
   return torch.DoubleTensor(r,c):apply(coinToss)
end

isAlive = function(mat)
   return mat[2][2] == 1
end

nextState = function(mat)
   local sum = mat:sum()
   if isAlive(mat) then
      if sum == 3 or sum == 4 then
	 return 1
      else
	 return 0
      end
   else
      if sum == 3 then
	 return 1
      else
	 return 0
      end
   end
end


conwaynn_simple = nn.Sequential()
conwaynn_simple:add(nn.Linear(9,1))

conwaynn_reasonable = nn.Sequential()
conwaynn_reasonable:add(nn.Linear(9,3))
conwaynn_reasonable:add(nn.Sigmoid())
conwaynn_reasonable:add(nn.Linear(3,1))

conwaynn = nn.Sequential()
conwaynn:add(nn.Linear(9,3))
conwaynn:add(nn.Sigmoid())
conwaynn:add(nn.Linear(3,5))
conwaynn:add(nn.Tanh())
conwaynn:add(nn.Linear(5,1))

pokeGym = function(targetnn) 
   
   criterion = nn.MSECriterion()
   for i = 1,1000000 do
      samplematrix = randomMatrix(3,3)
      output = torch.DoubleTensor({nextState(samplematrix)})
      input = samplematrix:reshape(9)

      criterion:forward(targetnn:forward(input), output)
      targetnn:zeroGradParameters()
      targetnn:backward(input, criterion:backward(targetnn.output, output))
      targetnn:updateParameters(0.01)
   end
   return targetnn
end

pokeGym(conwaynn)
pokeGym(conwaynn_reasonable)
pokeGym(conwaynn_simple)

tests = { torch.DoubleTensor({ {0,0,0}, {0,1,0}, {0,0,0} }),
	  torch.DoubleTensor({ {0,1,0}, {0,1,0}, {0,0,0} }),
	  torch.DoubleTensor({ {0,1,0}, {0,1,0}, {0,0,1} }),
	  torch.DoubleTensor({ {0,1,0}, {1,1,0}, {0,0,1} }),
	  torch.DoubleTensor({ {1,1,0}, {1,1,0}, {0,0,1} }),
	  torch.DoubleTensor({ {1,1,0}, {1,1,0}, {1,1,1} }),
	  torch.DoubleTensor({ {0,1,0}, {1,0,0}, {0,0,1} }),
	  torch.DoubleTensor({ {0,0,0}, {1,0,0}, {0,0,1} }) }

nets = { conwaynn_simple, conwaynn, conwaynn_reasonable }

calcScore = function(netnn)
   correct = 0
   incorrect = 0

   for i,k in ipairs(tests) do
      res = netnn:forward(k:reshape(9))
      if res[1] > 0.9 and nextState(k) == 1 then
	 correct = correct + 1
      elseif res[1] < 0.9 and nextState(k) == 0 then
	 correct = correct + 1
      else
	 incorrect = incorrect + 1
      end
   end
   print(name,correct, incorrect)
end

for name, netnn in ipairs(nets) do
   calcScore(netnn)
end

print('Time elapsed for 1,000,000 sin: ' .. timer:time().real .. ' seconds')

