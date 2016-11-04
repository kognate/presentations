require 'nn'

stoplight = nn.Sequential()
stoplight:add(nn.Linear(4,1))

criterion = nn.MSECriterion()

lights = {
   torch.Tensor({0,0,0,0}),
   torch.Tensor({0,0,0,1}),
   torch.Tensor({0,0,1,0}),
   torch.Tensor({0,1,0,0}),
   torch.Tensor({1,0,0,0}),
   torch.Tensor({1,0,0,1}),
   torch.Tensor({0,1,1,0}),
   torch.Tensor({1,0,1,0}),
   torch.Tensor({0,1,0,1}),
   torch.Tensor({1,1,0,0}),
   torch.Tensor({0,0,1,1}),
   torch.Tensor({1,0,1,1}),
   torch.Tensor({1,1,0,1}),
   torch.Tensor({1,1,1,0}),
   torch.Tensor({1,1,1,1})
}


for i = 1,15 do

   input = lights[i]
   output = torch.Tensor({ 0 })
   
   -- the only safe one is the 15th
   if i == 15 then
      output = torch.Tensor({ 1 })
   end
   criterion:forward(stoplight:forward(input), output)
   
   -- train over this example in 3 steps
   -- (1) zero the accumulation of the gradients
   stoplight:zeroGradParameters()
   -- (2) accumulate gradients
   stoplight:backward(input, criterion:backward(stoplight.output, output))
   -- (3) update parameters with a 0.01 learning rate
   stoplight:updateParameters(0.1)
end

print(stoplight:forward(torch.Tensor({1,1,1,1})))
print(stoplight:forward(torch.Tensor({1,1,1,0})))
print(stoplight:forward(torch.Tensor({0,1,1,0})))
